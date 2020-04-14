# -*- coding: utf-8 -*-
import oss2, json
import os
import logging

OSS_DEST_REGION = os.environ["OSS_DEST_REGION"]
OSS_DEST_BUCKET = os.environ["OSS_DEST_BUCKET"]
OSS_DEST_AK_ID = os.environ["OSS_DEST_AK_ID"]
OSS_DEST_AK_SK = os.environ["OSS_DEST_AK_SK"]
OSS_DEST_CALLBACK = os.environ["OSS_DEST_CALLBACK"]

# Close the info log printed by the oss SDK
logging.getLogger("oss2.api").setLevel(logging.ERROR)
logging.getLogger("oss2.auth").setLevel(logging.ERROR)

def handler(event, context):
  evt_lst = json.loads(event)
  print(evt_lst)
  creds = context.credentials
  auth=oss2.StsAuth(
    creds.access_key_id,
    creds.access_key_secret,
    creds.security_token)

  evt = evt_lst['events'][0]
  bucket_name = evt['oss']['bucket']['name']
  endpoint = 'oss-' +  evt['region'] + '-internal.aliyuncs.com'
  bucket = oss2.Bucket(auth, endpoint, bucket_name)
  object_name = evt['oss']['object']['key']
  
  r = bucket.get_object(object_name)
  
  headers = None
  # copy object 去另外一个region
  
  ''' 如果有自定义的callback， 可以参考如下code
  call_back_event = {} # 用户自定义的参数，这里示例是一个空的dict
  callback_dict = {}
  callback_dict['callbackUrl'] = OSS_DEST_CALLBACK
  callback_body = '&'.join(['{0!s}={1!s}'.format(k, v) for k, v in call_back_event.items()])
  callback_dict['callbackBody'] = callback_body
  callback_dict['callbackBodyType'] = 'application/x-www-form-urlencoded'

  callback_param = json.dumps(callback_dict).strip()
  base64_callback_body = base64.b64encode(bytes(callback_param, encoding='utf-8'))
  base64_callback_body = str(base64_callback_body, encoding='utf-8')
  headers = {'x-oss-callback': base64_callback_body}
  '''
  
  # 备份到另外一个region的bucket
  oss_dest_auth = oss2.Auth(OSS_DEST_AK_ID, OSS_DEST_AK_SK)
  oss_dest_bucket = oss2.Bucket(oss_dest_auth, OSS_DEST_REGION, OSS_DEST_BUCKET)
  oss_dest_bucket.put_object(filename, r, headers)
  
  # 备份到NAS
  # 写入函数计算挂载的nas，假设挂载的目录为 /mnt/nas_dir
  with open("/mnt/nas_dir","w") as f:
        f.write(r.read())