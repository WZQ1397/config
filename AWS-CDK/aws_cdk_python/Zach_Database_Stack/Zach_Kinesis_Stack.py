# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-11-06 13:30
from aws_cdk import core, aws_kinesis as ks , aws_kms as kms
import os

class Zach_Kinesis_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ZachStreamName="ZachWang"
        ksStream = ks.Stream(self,id=ZachStreamName,stream_name=ZachStreamName,
                             encryption=ks.StreamEncryption.KMS,
                             encryption_key=self.GenerateKmsKey(ZachStreamName),
                             shard_count=2,retention_period_hours=168)
        core.CfnOutput(self, ZachStreamName + "Stream-ARN", value=ksStream.stream_arn)
        core.CfnOutput(self, ZachStreamName + "Stream-Name", value=ksStream.stream_name)

    def GenerateKmsKey(self,ZachStreamName):
        KeyName=ZachStreamName + "KmsKey"
        ZachKey= kms.Key(self, id=KeyName,
                         description="KMS Key for kinesis " + ZachStreamName,
                         enabled=True, enable_key_rotation=True)
        ZachKey.add_alias(KeyName)
        core.CfnOutput(self, KeyName + "ARN", value=ZachKey.key_arn)
        core.CfnOutput(self, KeyName + "ID", value=ZachKey.key_id)
        return ZachKey