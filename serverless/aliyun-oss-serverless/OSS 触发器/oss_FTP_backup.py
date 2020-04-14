# -*- coding: utf-8 -*-
import oss2, json
import os
import logging
import requests
from hashlib import md5
import datetime, time
from ftplib import FTP

GMT_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
LOGGER = logging.getLogger()
MD5_HTTP_URL = "<http server url>"

# 将对应的ftp 信息改写正确
FTP_ADDR = "<ftp addr>"
FTP_PORT = 21
FTP_USER = "<ftp-user-name>"
FTP_PWD = "123456"
FTP_SAVE_ROOT_PATH = "/home/remote1/"


# Close the info log printed by the oss SDK
logging.getLogger("oss2.api").setLevel(logging.ERROR)
logging.getLogger("oss2.auth").setLevel(logging.ERROR)

def handler(event, context):
  evt_lst = json.loads(event)
  #print(evt_lst)
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
  m = md5()
  while 1:
    data = r.read(4096)
    if not data:
      break
    m.update(data)
  md5_value = m.hexdigest()

  objectmeta = bucket.head_object(object_name)
  last_modified = objectmeta.headers['Last-Modified']
  
  # convert timeformat from GMT to YYYYMMDDHHmmss
  dt = datetime.datetime.strptime(last_modified, GMT_FORMAT)
  time_t = time.strftime("%Y%m%d%H%M%S", dt.utctimetuple())
  
  payload = {'md5': md5_value, 'time': time_t, 'filePath': object_name, 'bucketName':bucket_name}
  
  # LOGGER.info(payload)
  r = requests.get(MD5_HTTP_URL, params=payload)
  
  # 异常处理
  if r.status_code >= 400:
    LOGGER.error("upload md5 fail, payload = {} , detail = {}".format(payload, r.text))
    
  # upload file to ftp server
  ftp = FTP()
  #ftp.set_debuglevel(2)
  ftp.connect(FTP_ADDR, FTP_PORT)
  ftp.login(FTP_USER, FTP_PWD)
  
  # 生成对应的目录, object key中有/, 即有目录，这边也处理成有目录
  ftp.cwd(FTP_SAVE_ROOT_PATH)
  parent_dir = os.path.dirname(object_name)
  if parent_dir:
    try:
      ftp.mkd(parent_dir)
    except:
      pass 
  
  sever_will_savefile = FTP_SAVE_ROOT_PATH + object_name
  try:
    remote_stream=bucket.get_object(object_name)
    ftp.storbinary('STOR ' +  sever_will_savefile, remote_stream)
  except Exception as e:
    LOGGER.error("upload ftp server fail, savefile ={}, detail = {}".format(sever_will_savefile, str(e)))
  finally:
    ftp.close()

  return "OK"