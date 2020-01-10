#!/usr/bin/env python3

from aws_cdk import core
from Zach_EC2_Stack import Zach_ELB_Stack
from Zach_Container_Stack import Zach_ECR_Stack_A
from Zach_Database_Stack import Zach_Kinesis_Stack,Zach_ElasticSearch_Stack,Zach_DynamoDB_Stack
from Zach_Storage_Stack import Zach_S3_Stack
app = core.App()
env={'region': "ap-southeast-1",'account':'098380756085'}
# Zach_VPC_Stack.Zach_VPC_Stack_A(app,"ZachVPCStackA")
# Zach_EC2_Stack.Zach_EC2_Stack_A(app,"ZachEC2StackA",env=env)
# Zach_EC2_AutoScale_Stack.Zach_EC2_AutoScale_Stack(app,"ZachEC2StackAutoScale",env=env)
Zach_S3_Stack.ZachS3Bucket(app,"ZachS3BucketA")
# Zach_IAM_Stack.Zach_IAM_Stack_A(app,"Zach-IAM-Role-A",env={'region': "ap-southeast-1",'account':'098380756085'})
# Zach_RDS_Stack.Zach_RDS_Stack_A(app,"Zach-RDS-A",env=env)
# Zach_EFS_Stack.Zach_EFS_Stack_A(app,"Zach-EFS-A",env=env)
# Zach_ElasticCache_Stack.Zach_Cache_Stack_A(app,"ZachCacheStackA",env=env)
# Zach_AWSBackup_Stack.Zach_AWSBackup_Stack_A(app,"ZachAWSBackupStackA",env=env) ???
# Zach_Lambda_Stack.PyStack(app, "cdk-py-lambda-cdk")
# Zach_ELB_Stack.Zach_ELB_Stack_A(app, "ZachELBStackA", env=env)
# Zach_ECS_Stack_A.Zach_ECS_Stack_A(app, "ZachECSA", env=env)
# Zach_ECS_Stack_B.Zach_ECS_Stack_B(app, "ZachECSB", env=env)
# Zach_ECS_Stack_C.Zach_ECS_Stack_C(app, "ZachECSC", env=env)
# Zach_Fargate_Stack_A.Zach_Fargate_Stack_A(app, "ZachFargateA", env=env) ???
# Zach_ECR_Stack_A.Zach_ECR_Stack_A(app,"ZachECRA", env=env)
# Zach_Kinesis_Stack.Zach_Kinesis_Stack_A(app,"ZachKinesisA", env=env)
# Zach_ElasticSearch_Stack.Zach_ElasticSearch_Stack_A(app,"ZachElasticSearchA", env=env) ???
# Zach_DynamoDB_Stack.Zach_DynamoDB_Stack_A(app,"ZachDynamoDBA", env=env)
app.synth()

