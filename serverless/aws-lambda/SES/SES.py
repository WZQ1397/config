from __future__ import print_function

def lambda_handler(event, context):
    print(event)
    message = event['Records'][0]['Sns']['Message']
    notification_type = event['Records'][0]['EventSource']
    print(message,notification_type)