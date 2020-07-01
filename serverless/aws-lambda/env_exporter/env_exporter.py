import json,os
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    
  try:
    print("function name:", context.function_name)
    print("function", context.function_name, "ARN:",  context.invoked_function_arn)
    print("Log stream name:", context.log_stream_name)
    print("Log group name:",  context.log_group_name)
    print("Request ID:",context.aws_request_id)
    print("Mem. limits(MB):", context.memory_limit_in_mb)
    print("Time remaining (MS):", context.get_remaining_time_in_millis())
    for k,v in os.environ.items():
      str = "{}: {}".format(k,v)
      logger.info(str)
  except Exception as e:
    raise Exception(e,'Error Occured!')
  finally:
    return "aws lambda in python using zip file"