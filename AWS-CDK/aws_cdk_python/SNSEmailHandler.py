# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-11-06 14:06

from __future__ import print_function
import json
import boto3
from botocore.exceptions import ClientError


def lambda_handler(event, context):
  message = json.loads(event['Records'][0]['Sns']['Message'])
  notification_type = message['notificationType']
  handlers.get(notification_type, handle_unknown_type)(message)


def handle_bounce(message):
  message_id = message['mail']['messageId']
  bounced_recipients = message['bounce']['bouncedRecipients']
  addresses = list(
    recipient['emailAddress'] for recipient in bounced_recipients
  )
  bounce_type = message['bounce']['bounceType']
  print("Message %s bounced when sending to %s. Bounce type: %s" %
        (message_id, ", ".join(addresses), bounce_type))


def handle_complaint(message):
  message_id = message['mail']['messageId']
  complained_recipients = message['complaint']['complainedRecipients']
  addresses = list(
    recipient['emailAddress'] for recipient in complained_recipients
  )
  print("A complaint was reported by %s for message %s." %
        (", ".join(addresses), message_id))


def handle_delivery(message):
  message_id = message['mail']['messageId']
  delivery_timestamp = message['delivery']['timestamp']
  header_from = message['mail']['commonHeaders']['from'][0]
  header_to = message['mail']['commonHeaders']['to'][0]
  print("Message %s was delivered successfully at %s" %
        (message_id, delivery_timestamp))
  SENDER = "feichashao-ses <feichashao@gmail.com>"
  RECIPIENT = "feichashao@qq.com"
  AWS_REGION = "us-west-2"
  SUBJECT = "Amazon SES Test (SDK for Python)"
  BODY_TEXT = ("Amazon SES Test (Python)\r\n"
               "This email was sent with Amazon SES using the "
               "AWS SDK for Python (Boto)."
               )

  BODY_HTML = """<html>
    <head></head>
    <body>
    <h1>Email Delivery</h1>
    <p>From: {}</p>
    <p>To: {}</p>
    </body>
    </html>
    """.format(header_from, header_to)
  CHARSET = "UTF-8"
  client = boto3.client('ses', region_name=AWS_REGION)

  try:
    # Provide the contents of the email.
    response = client.send_email(
      Destination={
        'ToAddresses': [
          RECIPIENT,
        ],
      },
      Message={
        'Body': {
          'Html': {
            'Charset': CHARSET,
            'Data': BODY_HTML,
          },
          'Text': {
            'Charset': CHARSET,
            'Data': BODY_TEXT,
          },
        },
        'Subject': {
          'Charset': CHARSET,
          'Data': SUBJECT,
        },
      },
      Source=SENDER,
    )
  # Display an error if something goes wrong.
  except ClientError as e:
    print(e.response['Error']['Message'])
  else:
    print("Email sent! Message ID:"),
    print(response['MessageId'])


def handle_unknown_type(message):
  print("Unknown message type:\n%s" % json.dumps(message))
  raise Exception("Invalid message type received: %s" %
                  message['notificationType'])


handlers = {"Bounce": handle_bounce,
            "Complaint": handle_complaint,
            "Delivery": handle_delivery}
