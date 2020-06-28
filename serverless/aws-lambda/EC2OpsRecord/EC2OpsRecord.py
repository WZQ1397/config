import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
def lambda_handler(event, context):

    str = "{}: {}".format('account',event['account'])
    logger.info(str)
    str = "{}: {}".format('OpsTime',event['time'])
    logger.info(str)
    str = "{}: {}".format('region',event['region'])
    logger.info(str)
    for k,v in event['detail'].items():
        str = "{}: {}".format(k,v)
        logger.info(str)
    print('ok')
    return 'success'