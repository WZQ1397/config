import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

print('Loading function')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    info = event['Records'][0]
    str = "{}: {}".format('Region',info['awsRegion'])
    logger.info(str)
    str = "{}: {}".format('OpsTime',info['eventTime'])
    logger.info(str)
    str = "{}: {}".format('ObjectOps',info['eventName'])
    logger.info(str)
    str = "{}: {}".format('userId',info['userIdentity']['principalId'])
    logger.info(str)
    str = "{}: {}".format('OpsIP',info['requestParameters']['sourceIPAddress'])
    logger.info(str)
    s3 = info['s3']
    str = "{}: {} ==> {}".format('BucketName',s3['bucket']['name'],s3['object']['key'])
    logger.info(str)