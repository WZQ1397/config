import os
import oss2
import zipfile
import shutil
import time,datetime

def handler(event, context):
    creds = context.credentials
    # print(creds.accessKeyId, creds.accessKeySecret, creds.securityToken)
    import dataexport
    dataexport.export2csv()
    # auth = oss2.StsAuth(creds.accessKeyId, creds.accessKeySecret, creds.securityToken)
    # src_bucket = oss2.Bucket(auth, 'oss-ap-southeast-1-internal.aliyuncs.com', 'suncash-dbdata-sync')
    # tgt_bucket = oss2.Bucket(auth, 'oss-cn-hangzhou.aliyuncs.com', 'spark99-prd')
    #your source list
    # sourceFile = ['config.ini']
    #zip name
    # day=datetime.datetime.now().strftime('%Y-%m-%d')
    # uid = 'suncash-'+day+'-dbdata'
    # tmpdir = '/mnt/zach/'+day
    
    # os.system("rm -rf /tmp/*")
    # os.mkdir(tmpdir)
       
    # #download
    # for name in sourceFile :
    #     millis = int(round(time.time() * 1000))
    #     src_bucket.get_object_to_file(name , tmpdir + str(millis))
    
    # #zip file
    # zipname = '/tmp/'+uid + '.zip'
    # make_zip(tmpdir , zipname)

    # #upload
    # total_size = os.path.getsize(zipname)
    # part_size = oss2.determine_part_size(total_size, preferred_size = 128 * 1024)

    # key = uid + '.zip'
    # upload_id = tgt_bucket.init_multipart_upload(key).upload_id
 
    # with open(zipname, 'rb') as fileobj:
    #     parts = []
    #     part_number = 1
    #     offset = 0
    #     while offset < total_size:
    #         num_to_upload = min(part_size, total_size - offset)
    #         result = tgt_bucket.upload_part(key, upload_id, part_number,oss2.SizedFileAdapter(fileobj, num_to_upload))
    #         parts.append(oss2.models.PartInfo(part_number, result.etag))
    #         offset += num_to_upload
    #         part_number += 1
            
    #     tgt_bucket.complete_multipart_upload(key, upload_id, parts)
        
    # return total_size


# def make_zip(source_dir, output_filename):
#     zipf = zipfile.ZipFile(output_filename, 'w')    
#     pre_len = len(os.path.dirname(source_dir))
#     for parent, dirnames, filenames in os.walk(source_dir):
#         for filename in filenames:
#             pathfile = os.path.join(parent, filename)
#             arcname = pathfile[pre_len:].strip(os.path.sep)     
#             zipf.write(pathfile, arcname)
#     zipf.close()