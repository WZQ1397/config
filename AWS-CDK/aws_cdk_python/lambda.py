
# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-22 17:46

import json
import boto3

def lambda_handler(event, context):
    try:
        # try to get data from form
        user_id = event['user_id']

    except:
        return {
            'statusCode': 200,
            'headers': {
                'access-control-allow-origin': '*',
                'content-type': 'application/json'
            },
            'completed': 0
        }

    # send data to Sagemaker
    client = boto3.client('sagemaker-runtime')
    data_send = json.dumps({"user_id": user_id})
    response = client.invoke_endpoint(
        EndpointName="commentableNewsRecommenderStg1",
        Body=data_send,
        ContentType='application/json',
        Accept='application/json'
    )

    result = response['Body'].read()
    result = result.decode('utf-8')
    result = json.loads(json.loads(result))  # 追加
    return result