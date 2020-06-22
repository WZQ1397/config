# -*- coding: utf-8 -*-
import logging
import json, random, string, time
from aliyunsdkcore import client
from aliyunsdkecs.request.v20140526.DeleteSnapshotRequest import DeleteSnapshotRequest
from aliyunsdkecs.request.v20140526.CreateSnapshotRequest import CreateSnapshotRequest
from aliyunsdkecs.request.v20140526.DescribeDisksRequest import DescribeDisksRequest
from aliyunsdkcore.auth.credentials import StsTokenCredential

LOGGER = logging.getLogger()
clt = None


def handler(event, context):
  creds = context.credentials
  sts_token_credential = StsTokenCredential(creds.access_key_id, creds.access_key_secret, creds.security_token)

  evt = json.loads(event)
  content = evt.get("content");
  ecsInstanceId = content.get("ecsInstanceId");
  regionId = evt.get("regionId");
  executeStartTime = evt.get("executeStartTime");
  eventType = evt.get("eventType");
  diskId = evt.get("diskId");
  status = evt.get("status")
  LOGGER.info("%s ==> %s",regionId, ecsInstanceId)
  LOGGER.info("executeStartTime: %s ==> %s [%s]",executeStartTime,eventType,status)
  LOGGER.info("diskId: %s",diskId)
  global clt
  clt = client.AcsClient(region_id=regionId, credential=sts_token_credential)
  name = evt.get("name");
  name = name.lower()

  if name in ['Instance:SystemFailure.Reboot:Executing'.lower(), "Instance:InstanceFailure.Reboot:Executing".lower()]:
    return "zach.wang"

  if name in ['Instance:SystemFailure.Reboot:Executed'.lower(), "Instance:InstanceFailure.Reboot:Executed".lower()]:
    request = DescribeDisksRequest()
    request.add_query_param("RegionId", regionId)
    request.set_InstanceId(ecsInstanceId)
    response = _send_request(request)
    disks = response.get('Disks').get('Disk', [])
    for disk in disks:
      diskId = disk["DiskId"]
      SnapshotId = create_ecs_snap_by_id(diskId)
      LOGGER.info("Create ecs snap sucess, ecs id = {} , disk id = {} ".format(ecsInstanceId, diskId))


def create_ecs_snap_by_id(disk_id):
  LOGGER.info("Create ecs snap, disk id is {} ".format(disk_id))
  request = CreateSnapshotRequest()
  request.set_DiskId(disk_id)
  request.set_SnapshotName("reboot_" + ''.join(random.choice(string.ascii_lowercase) for _ in range(6)))
  response = _send_request(request)
  return response.get("SnapshotId")


# send open api request
def _send_request(request):
  request.set_accept_format('json')
  try:
    response_str = clt.do_action_with_exception(request)
    LOGGER.info(response_str)
    response_detail = json.loads(response_str)
    return response_detail
  except Exception as e:
    LOGGER.error(e)