# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-21 10:04
from aws_cdk import core, aws_s3 as s3 , aws_s3_notifications as s3n , aws_lambda as lm

class ZachS3Bucket(core.Stack):

  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)

    ZachS3Bucket = s3.Bucket(self, 'ZachS3Bucket',versioned=False,
                             removal_policy=core.RemovalPolicy.DESTROY,
                             # block_public_access=s3.BlockPublicAccess()
                             )
    ZachS3BucketAllowMethod = [s3.HttpMethods.GET, s3.HttpMethods.POST]
    ZachS3Bucket.add_cors_rule(allowed_methods=ZachS3BucketAllowMethod
                               , allowed_origins=['192.168.0.0/24'])
    ZachS3BucketLongTermStorageClass = s3.StorageClass.INFREQUENT_ACCESS
    ZachS3Bucket.add_lifecycle_rule(enabled=True,
                                    expiration=core.Duration.days(42),
                                    prefix="Zach-tsjr",
                                    tag_filters={"Environment": "Dev", "FileType": "Log"},
                                    transitions=[s3.Transition(storage_class=ZachS3BucketLongTermStorageClass,
                                                               transition_after=core.Duration.days(30))]
                                    )
    s3_logger_handler=lm.Function(
      self, "ZachS3BucketLambda",
      runtime=lm.Runtime.PYTHON_3_7,
      handler="s3recorder.handler",
      code=lm.Code.asset('aws_cdk_python\Zach_Lambda_Stack'),
      environment={
        "S3_BUCKET": ZachS3Bucket.bucket_name
      }
    )
    notify_lambda = s3n.LambdaDestination(s3_logger_handler)
    ZachS3Bucket.add_event_notification(s3.EventType.OBJECT_CREATED,notify_lambda)
    # ZachS3Bucket.grant_write(notify_lambda)
    core.CfnOutput(self, id="ZachS3BucketARN", value=ZachS3Bucket.bucket_arn)
    core.CfnOutput(self,id="ZachS3BucketName",value=ZachS3Bucket.bucket_name)
    core.CfnOutput(self,id="ZachS3BucketOverview",value=ZachS3Bucket.to_string())
