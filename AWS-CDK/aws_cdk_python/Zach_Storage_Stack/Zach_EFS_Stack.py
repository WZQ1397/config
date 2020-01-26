# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-21 18:11
from aws_cdk import core,aws_efs as efs,aws_ec2 as ec2


class Zach_EFS_Stack_A(core.Stack):

  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)

    FS_TAGS=[efs.CfnFileSystem.ElasticFileSystemTagProperty(key="Environment",value="Development"),
             efs.CfnFileSystem.ElasticFileSystemTagProperty(key="NFSver",value="4.1")]
    FS_LIFE_POLICY = efs.CfnFileSystem.LifecyclePolicyProperty(transition_to_ia="AFTER_14_DAYS")
    Zach_EFS_NAME=self.__class__.__name__
    FS_SG_VPC= ec2.Vpc.from_lookup(self,id="Zach_VPC_Stack_A",vpc_id="vpc-03813ad7db2dc5cf2")
    FS_SG=ec2.SecurityGroup(self,id=Zach_EFS_NAME+"-SG",allow_all_outbound=True,description="SG of EFS",security_group_name=Zach_EFS_NAME+"-SG",vpc=FS_SG_VPC)
    FS_SG_IP_LIST = ["192.168.0.0/24","10.0.1.0/24","222.66.149.30/32"]
    for IP in  FS_SG_IP_LIST:
      FS_SG.add_ingress_rule(peer=ec2.Peer.ipv4(cidr_ip=IP),connection=ec2.Port.all_tcp())
      FS_SG.add_ingress_rule(peer=ec2.Peer.ipv4(cidr_ip=IP), connection=ec2.Port.all_udp())
    Zach_EFS=efs.CfnFileSystem(self,id=Zach_EFS_NAME,encrypted=False,
                      #lifecycle_policies=FS_LIFE_POLICY,
                      file_system_tags=FS_TAGS,
                      performance_mode="generalPurpose",
                      throughput_mode="bursting")
    Zach_EFS_MOUNT = efs.CfnMountTarget(self,id=Zach_EFS_NAME+"MountPoint",
                                  file_system_id=Zach_EFS.ref,
                                  security_groups=[FS_SG.security_group_id],
                                  subnet_id="subnet-06bd5699b2dd1b3d7")
    core.CfnOutput(self, id="ZachEFS-A-ID", value=Zach_EFS.logical_id)
    core.CfnOutput(self, id="ZachEFS-A-FileSYSID", value=Zach_EFS.ref)
    core.CfnOutput(self, id="ZachEFS-A-Pref-Mode", value=Zach_EFS.performance_mode)
    core.CfnOutput(self, id="ZachEFS-A-IO-Mode", value=Zach_EFS.throughput_mode)
    core.CfnOutput(self, id="ZachEFS-A-TAGS", value=Zach_EFS.file_system_tags.to_string())
