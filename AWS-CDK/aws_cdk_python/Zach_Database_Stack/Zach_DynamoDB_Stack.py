# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-22 13:35

from aws_cdk import core,aws_dynamodb as dy

class Zach_DynamoDB_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ZachDynamoDBInstanceName =  self.__class__.__name__
        ZachDynamoDBInstance = dy.Table(self,id=ZachDynamoDBInstanceName,table_name=ZachDynamoDBInstanceName,
                                        partition_key=dy.Attribute(name="UID",type=dy.AttributeType.NUMBER),
                                        billing_mode=dy.BillingMode.PROVISIONED,read_capacity=3,
                                        removal_policy=core.RemovalPolicy.DESTROY,
                                        server_side_encryption=True,
                                        sort_key=dy.Attribute(name="Date",type=dy.AttributeType.STRING),
                                        stream=dy.StreamViewType.KEYS_ONLY,
                                        write_capacity=3)

        core.CfnOutput(self, ZachDynamoDBInstanceName+"TableARN", value=str(ZachDynamoDBInstance.table_arn))
        core.CfnOutput(self, ZachDynamoDBInstanceName+"TableName", value=str(ZachDynamoDBInstance.table_name))
