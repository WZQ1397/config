# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-18 18:04

from aws_cdk import core,aws_ec2 as ec2

class Zach_VPC_Stack_A(core.Stack):

  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)

    # ZachEC2Stack_A_CONFIG={
    #   "VPC_ID": "ZachEC2Stack_A",
    #   "VPC_CIDR":"192.168.0.0/26",
    #   "VPC_SUBNET_TYPE": ec2.SubnetType.PUBLIC,
    #   "VPC_SG": {
    #     "AllowRemoteConsole":[22,9622],
    #     "AllowWebPort":[80,8080,5000]
    #   }
    # }
    # VPC_ID=ZachEC2Stack_A_CONFIG.get("VPC_ID","ZachStack_A")
    # VPC_CIDR=ZachEC2Stack_A_CONFIG.get("VPC_CIDR", "10.0.0.0/16")
    # VPC_SUBNET_TYPE=ZachEC2Stack_A_CONFIG.get("VPC_SUBNET_TYPE",ec2.SubnetType.PUBLIC)
    # ZachEc2Stack_A_VPC = ec2.Vpc(self,id=VPC_ID,
    #                              cidr=VPC_CIDR,
    #                              subnet_configuration=[{"cidrMask": 26, "name": VPC_ID, "subnetType": VPC_SUBNET_TYPE}],
    #                              enable_dns_hostnames=True,
    #                              enable_dns_support=True,
    #                              max_azs=1
    #                              )
    #
    # for Rule,PortList in ZachEC2Stack_A_CONFIG['VPC_SG'].items():
    #   ZachEc2Stack_A_SG_NAME=VPC_ID + "_SG_" + Rule
    #   ZachEc2Stack_A_SG=ec2.SecurityGroup(self,id=ZachEc2Stack_A_SG_NAME,
    #                                       vpc=ZachEc2Stack_A_VPC,
    #                                       security_group_name=ZachEc2Stack_A_SG_NAME,
    #                                       allow_all_outbound=True)
    #   for SgPort in PortList:
    #     ZachEc2Stack_A_SG.add_ingress_rule(peer=ec2.Peer.ipv4("222.66.149.30/32"),connection=ec2.Port.tcp(SgPort))
    #
    # core.CfnOutput(self,"ZachEC2Stack_A_SG",value=ZachEc2Stack_A_SG.security_group_name)
    #
    #
    # ZachEC2Stack_B_CONFIG = {
    #   "VPC_ID": "ZachEC2Stack_B",
    #   "VPC_CIDR": "192.168.1.0/26",
    #   "VPC_SUBNET_TYPE": ec2.SubnetType.PUBLIC,
    #   "VPC_SG": {
    #     "AllowRemoteConsole": [22, 9622],
    #     "AllowWebPort": [80, 8080, 5000]
    #   }
    # }
    # VPC_ID = ZachEC2Stack_B_CONFIG.get("VPC_ID", "ZachStack_B")
    # VPC_CIDR = ZachEC2Stack_B_CONFIG.get("VPC_CIDR", "10.0.0.0/16")
    # VPC_SUBNET_TYPE = ZachEC2Stack_B_CONFIG.get("VPC_SUBNET_TYPE", ec2.SubnetType.PUBLIC)
    # ZachEc2Stack_B_VPC = ec2.Vpc(self, id=VPC_ID,
    #                              cidr=VPC_CIDR,
    #                              subnet_configuration=[
    #                                {"cidrMask": 26, "name": VPC_ID, "subnetType": VPC_SUBNET_TYPE}],
    #                              enable_dns_hostnames=True,
    #                              enable_dns_support=True,
    #                              max_azs=1
    #                              )
    #
    # for Rule, PortList in ZachEC2Stack_B_CONFIG['VPC_SG'].items():
    #   ZachEc2Stack_B_SG_NAME = VPC_ID + "_SG_" + Rule
    #   ZachEc2Stack_B_SG = ec2.SecurityGroup(self, id=ZachEc2Stack_B_SG_NAME,
    #                                         vpc=ZachEc2Stack_B_VPC,
    #                                         security_group_name=ZachEc2Stack_B_SG_NAME,
    #                                         allow_all_outbound=True)
    #   for SgPort in PortList:
    #     ZachEc2Stack_B_SG.add_ingress_rule(peer=ec2.Peer.ipv4("222.66.149.30/32"), connection=ec2.Port.tcp(SgPort))
    #
    # core.CfnOutput(self, "ZachEC2Stack_B_SG", value=ZachEc2Stack_B_SG.security_group_name)
    #
    # ZachEC2Stack_Priv_CONFIG = {
    #   "VPC_ID": "ZachEC2Stack_Priv",
    #   "VPC_CIDR": "192.168.100.0/26",
    #   "VPC_SUBNET_TYPE": ec2.SubnetType.PRIVATE,
    #   "VPC_SG": {
    #     "AllowRemoteConsole": [22, 9622],
    #     "AllowWebPort": [80, 8080, 5000]
    #   }
    # }
    # VPC_ID = ZachEC2Stack_Priv_CONFIG.get("VPC_ID", "ZachStack_Priv")
    # VPC_CIDR = ZachEC2Stack_Priv_CONFIG.get("VPC_CIDR", "10.0.0.0/16")
    # # VPC_SUBNET_TYPE = ZachEC2Stack_Priv_CONFIG.get("VPC_SUBNET_TYPE", ec2.SubnetType.PUBLIC)
    # ZachEc2Stack_Priv_VPC = ec2.Vpc(self, id=VPC_ID,
    #                              cidr=VPC_CIDR,
    #                              nat_gateways=1,max_azs=1
    #                              )
    #
    # for Rule, PortList in ZachEC2Stack_Priv_CONFIG['VPC_SG'].items():
    #   ZachEc2Stack_Priv_SG_NAME = VPC_ID + "_SG_" + Rule
    #   ZachEc2Stack_Priv_SG = ec2.SecurityGroup(self, id=ZachEc2Stack_Priv_SG_NAME,
    #                                         vpc=ZachEc2Stack_Priv_VPC,
    #                                         security_group_name=ZachEc2Stack_Priv_SG_NAME,
    #                                         allow_all_outbound=True)
    #   for SgPort in PortList:
    #     ZachEc2Stack_Priv_SG.add_ingress_rule(peer=ec2.Peer.ipv4("222.66.149.30/32"), connection=ec2.Port.tcp(SgPort))
    #
    # core.CfnOutput(self, "ZachEC2Stack_Priv_SG", value=ZachEc2Stack_Priv_SG.security_group_name)

    ZachEC2Stack_Muti_CONFIG = {
      "VPC_ID": "ZachEC2Stack_Muti",
      "VPC_CIDR": "192.168.200.0/24",
      "VPC_SUBNET_TYPE": ec2.SubnetType.PUBLIC,
      "VPC_SG": {
        "AllowRemoteConsole": [22, 9622],
        "AllowWebPort": [80, 8080, 5000]
      }
    }
    VPC_ID = ZachEC2Stack_Muti_CONFIG.get("VPC_ID", "ZachStack_Muti")
    VPC_CIDR = ZachEC2Stack_Muti_CONFIG.get("VPC_CIDR", "10.0.0.0/16")
    VPC_SUBNET_TYPE = ZachEC2Stack_Muti_CONFIG.get("VPC_SUBNET_TYPE", ec2.SubnetType.PUBLIC)
    ZachEc2Stack_Muti_VPC = ec2.Vpc(self, id=VPC_ID,
                                 cidr=VPC_CIDR,
                                 subnet_configuration=[
                                   {"cidrMask": 26, "name": VPC_ID, "subnetType": VPC_SUBNET_TYPE}],
                                 enable_dns_hostnames=True,
                                 enable_dns_support=True,
                                 max_azs=3
                                 )

    for Rule, PortList in ZachEC2Stack_Muti_CONFIG['VPC_SG'].items():
      ZachEc2Stack_Muti_SG_NAME = VPC_ID + "_SG_" + Rule
      ZachEc2Stack_Muti_SG = ec2.SecurityGroup(self, id=ZachEc2Stack_Muti_SG_NAME,
                                            vpc=ZachEc2Stack_Muti_VPC,
                                            security_group_name=ZachEc2Stack_Muti_SG_NAME,
                                            allow_all_outbound=True)
      for SgPort in PortList:
        ZachEc2Stack_Muti_SG.add_ingress_rule(peer=ec2.Peer.ipv4("222.66.149.30/32"), connection=ec2.Port.tcp(SgPort))

    core.CfnOutput(self, "ZachEC2Stack_Muti_SG", value=ZachEc2Stack_Muti_SG.security_group_name)