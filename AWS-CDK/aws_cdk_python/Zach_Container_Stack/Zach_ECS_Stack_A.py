# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-28 9:56

from aws_cdk import core, aws_ec2 as ec2 , aws_autoscaling as autoscaling , aws_ecs as ecs


class Zach_ECS_Stack_A(core.Stack):

  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)
    ZachECSName= self.__class__.__name__
    vpc = ec2.Vpc(
      self, ZachECSName+"Vpc",
      max_azs=2
    )

    asg = autoscaling.AutoScalingGroup(
      self, ZachECSName+"SCG" ,
      instance_type=ec2.InstanceType("t3a.nano"),
      machine_image=ecs.EcsOptimizedAmi(),
      associate_public_ip_address=True,
      update_type=autoscaling.UpdateType.REPLACING_UPDATE,
      desired_capacity=3,
      vpc=vpc,
      vpc_subnets={'subnetType': ec2.SubnetType.PUBLIC}
    )

    cluster = ecs.Cluster(
      self, ZachECSName+"Cluster",
      vpc=vpc
    )

    cluster.add_auto_scaling_group(asg)
    cluster.add_capacity(ZachECSName+"AutoScalingGroup",
                         instance_type=ec2.InstanceType("t3a.nano"))