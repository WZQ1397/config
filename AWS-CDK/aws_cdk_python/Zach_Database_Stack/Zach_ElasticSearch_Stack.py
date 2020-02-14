# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-22 13:35

from aws_cdk import core,aws_elasticsearch as es, aws_ec2 as ec2, aws_kms as kms

class Zach_ElasticSearch_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ZachESInstanceName = self.__class__.__name__
        DiskOpt={
          "EBSEnabled" : True,
          "VolumeSize" : 10,
          "VolumeType" : "gp2"
        }
        ESconfig = {
          "DedicatedMasterCount" : 3,
          "DedicatedMasterEnabled" : True,
          "DedicatedMasterType" : "m4.large.elasticsearch",
          "InstanceCount" : 3,
          "InstanceType" : "m4.large.elasticsearch",
          "ZoneAwarenessEnabled" : True
        }
        vpc = ec2.Vpc.from_lookup(self,id="Zach_VPC_Stack_A",vpc_id="vpc-01e73b4b5c6f9f98a")

        SubnetIDList,SGList=[],[]
        for subnet in vpc.public_subnets:
          SubnetIDList.append(subnet.subnet_id)

        vpc_options={"SubnetIds" :SubnetIDList,
                     "SecurityGroupIds" : []}

        '''
        EBS storage must be selected for m4.large.elasticsearch (Service: AWSElasticsearch; Status Code: 400; Error Code: ValidationException
        '''
        ZachESInstance=es.CfnDomain(self, id=ZachESInstanceName,
                                    domain_name=ZachESInstanceName.replace("_","").lower(),
                                    ebs_options=DiskOpt,
                                    elasticsearch_version='7.1',
                                    snapshot_options={"AutomatedSnapshotStartHour":2},
                                    vpc_options=vpc_options,
                                    elasticsearch_cluster_config=ESconfig,
                                    tags=[core.Tag(key="Environment",value="prod"),
                                          core.Tag(key="Type",value="Log")],
                                    encryption_at_rest_options={"Enabled": True,"KmsKeyId": self.GenerateKmsKey(ZachESInstanceName)},
                                    node_to_node_encryption_options={"Enabled" : True},
                                    advanced_options={"indices.query.bool.max_clause_count":"2000"}
                                    )
        core.CfnOutput(self, ZachESInstanceName + "ID", value=ZachESInstance.logical_id)
        core.CfnOutput(self, ZachESInstanceName + "Domain", value=ZachESInstance.domain_name)
        core.CfnOutput(self, ZachESInstanceName + "Ver", value=ZachESInstance.elasticsearch_version)
        core.CfnOutput(self, ZachESInstanceName + "VPC", value=ZachESInstance.vpc_options.to_string())

    def GenerateKmsKey(self,ZachStreamName):
        KeyName=ZachStreamName + "KmsKey"
        ZachKey= kms.Key(self, id=KeyName,
                         description="KMS Key for kinesis " + ZachStreamName,
                         enabled=True, enable_key_rotation=True)
        ZachKey.add_alias(KeyName)
        core.CfnOutput(self, KeyName + "ARN", value=ZachKey.key_arn)
        core.CfnOutput(self, KeyName + "ID", value=ZachKey.key_id)
        return ZachKey