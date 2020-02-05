# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-24 11:08

import os
from typing import List

from aws_cdk import aws_autoscaling as autoscaling
from aws_cdk import aws_ec2 as ec2
from aws_cdk import aws_iam as iam
from aws_cdk import core


class Zach_EC2_AutoScale_Stack(core.Stack):

    def _add_role(self) -> iam.Role:
        """
        Add IAM role to the stack
        """
        role = iam.Role(
            self, 'zachInstanceRole',
            assumed_by=iam.ServicePrincipal('ec2.amazonaws.com')
        )
        # add access to outputs of the current stack to ec2 instance
        role.add_to_policy(
            iam.PolicyStatement(
                resources=[self.format_arn(resource="stack/ZachEC2StackAutoScale/*", service="cloudformation")],
                actions=['cloudformation:*']
            ))
        # add policy to allow elastic ip association
        role.add_to_policy(
            iam.PolicyStatement(
                resources=['*'],
                actions=['ec2:AssociateAddress']
            )
        )
        return role

    def _create_public_subnet(self) -> ec2.SubnetConfiguration:
        """
        Configure a public subnet
        """
        return ec2.SubnetConfiguration(
            name='zach-application',
            subnet_type=ec2.SubnetType.PUBLIC,
        )

    def _add_vpc(self, subnets: List[ec2.SubnetConfiguration]) -> ec2.Vpc:
        """
        Add VPC to the stack
        :param subnets: list of available subnets
        """
        return ec2.Vpc(
            self,
            'zach-vpc',
            cidr='10.1.0.0/24',
            subnet_configuration=subnets
        )

    def _add_security_groups(self, vpc: ec2.Vpc) -> ec2.SecurityGroup:
        """
        Add security group to the stack
        :param vpc: VPC of security group
        """
        security_group = ec2.SecurityGroup(
            self,
            'zach-security-group',
            vpc=vpc,
            description="Allow access to zach instance",
            allow_all_outbound=True
        )
        security_group.add_ingress_rule(
                ec2.Peer.any_ipv4(),
                ec2.Port.tcp(9622),
                'allow ssh access from the world'
            )
        security_group.add_ingress_rule(
            ec2.Peer.any_ipv4(),
            ec2.Port.udp(500),
            'for IKE, to manage encryption keys'
        )
        security_group.add_ingress_rule(
            ec2.Peer.any_ipv4(),
            ec2.Port.udp(4500),
            'for IPSEC NAT-Traversal mode'
        )
        return security_group

    def _add_autoscaling_group(
            self,
            vpc: ec2.Vpc,
            public_subnet: ec2.SubnetConfiguration,
            security_group: ec2.SecurityGroup,
            role: iam.Role) -> autoscaling.AutoScalingGroup:
        """
        Add autoscaling group for running ec2 instance automatically
        """
        Zach_Ec2_InstanceImage = ec2.GenericLinuxImage(ami_map={"ap-southeast-1":"ami-048a01c78f7bae4aa"})

        group = autoscaling.AutoScalingGroup(
            self,
            'zach-autoscale',
            vpc=vpc,
            instance_type=ec2.InstanceType.of(ec2.InstanceClass.BURSTABLE2, ec2.InstanceSize.MICRO),
            machine_image=Zach_Ec2_InstanceImage,
            max_capacity=1,
            vpc_subnets=public_subnet,
            associate_public_ip_address=True,
            key_name='aws-sg-root',
            role=role
        )
        group.add_security_group(security_group)
        return group

    def _add_bootstrap_script_to_ec2(self, group: autoscaling.AutoScalingGroup):
        """
        Copy boostrap script to user data. Ec2 instance runs this script during initialization
        """
        with open('aws_cdk_python/Zach_EC2_Stack/bootstrap.sh', 'r') as f:
            commands = [l for l in f.readlines()[1:] if l.strip()]
        group.add_user_data(
            *commands
        )

    def __init__(self, scope: core.Construct, id: str, **kwargs):
        super().__init__(scope, id, **kwargs)

        # add elastic IP to the stack

        elastic_ip = ec2.CfnEIP(self, "zach-elastic-ip")

        # create public subnet to place ec2 instance for public access
        public_subnet = self._create_public_subnet()

        # create a role associated with vpc instance
        role = self._add_role()

        # create vpc with public subnet
        vpc = self._add_vpc([public_subnet])

        # add security group
        security_group = self._add_security_groups(vpc)

        # add autoscaling group
        Zach_Ec2_Instance = self._add_autoscaling_group(vpc, public_subnet, security_group, role)

        # add bootstrap script
        self._add_bootstrap_script_to_ec2(Zach_Ec2_Instance)

        # publish resource output
        core.CfnOutput(
            self, "AllocationId",
            description="The ID that AWS assigns to represent the allocation of the address for use with Amazon VPC. "
                        "This is returned only for VPC elastic IP addresses. For example, eipalloc-5723d13e.",
            value=elastic_ip.get_att('AllocationId').to_string()
        )
        core.CfnOutput(self, "InstanceSubnetType",value=public_subnet.subnet_type.value)
        core.CfnOutput(self, "InstanceOS", value=Zach_Ec2_Instance.os_type.value)
        core.CfnOutput(self, "InstanceRole", value=role.role_arn)
        core.CfnOutput(self, "InstanceBindSG",value=str(Zach_Ec2_Instance.connections.security_groups))
        core.CfnOutput(self, "AutoScaleName", value=Zach_Ec2_Instance.auto_scaling_group_name)
        core.CfnOutput(self, "AutoScaleARN", value=Zach_Ec2_Instance.auto_scaling_group_arn)
