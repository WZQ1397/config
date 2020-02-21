# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-24 13:33
from aws_cdk import core,aws_elasticloadbalancingv2 as elb , aws_ec2 as ec2 , aws_autoscaling as autoscaling


class Zach_ELB_Stack_A(core.Stack):

  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)
    Zach_LB_Name = self.__class__.__name__
    LB_VPC = ec2.Vpc.from_lookup(self, id="Zach_VPC_Stack_A", vpc_id="vpc-01e73b4b5c6f9f98a")
    LB_SG = ec2.SecurityGroup.from_security_group_id(self,id=Zach_LB_Name+"-SG",security_group_id="sg-07a1d71bba92f38ca")
    LB_Subnet = ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC)
    Zach_LB = elb.ApplicationLoadBalancer(self, id=Zach_LB_Name,
                                          idle_timeout=core.Duration.seconds(5),
                                          ip_address_type=elb.IpAddressType.IPV4,
                                          security_group=LB_SG,
                                          vpc=LB_VPC,
                                          deletion_protection=True,
                                          vpc_subnets=LB_Subnet,
                                          internet_facing=True,
                                          http2_enabled=True
                                          )
    # LB_Targets = elb.CfnTargetGroup(self,id=Zach_LB_Name,targets=[{
    #   "AvailabilityZone": "ap-southeast-1",
    #   "id": "i-0735304dcf665f40e",
    #   "Port": 80
    # }])
    LB_Targets = self._add_autoscaling_group(LB_VPC,LB_Subnet,LB_SG,'aws-sg-root')
    Zach_LB_Listener = Zach_LB.add_listener(id=Zach_LB_Name + "_" + str(80), open=True,port=80,protocol=elb.ApplicationProtocol.HTTP)

    Zach_LB_Listener.add_targets(id=Zach_LB_Name,health_check = elb.HealthCheck(healthy_http_codes="200,301,302,401,403,405",
                                                                                healthy_threshold_count=3,
                                                                                unhealthy_threshold_count=5,
                                                                                path="/",
                                                                                interval=core.Duration.seconds(30)),
                                 port = 80,
                                 protocol = elb.ApplicationProtocol.HTTP,
                                 # priority = 100,
                                 # path_pattern = '/',
                                 stickiness_cookie_duration = core.Duration.hours(12),
                                 targets=[LB_Targets],
                                 # target_group_name=LB_Targets.auto_scaling_group_name
                                 )

    Zach_LB_Listener.connections.allow_default_port_from_any_ipv4("Open to the world")
    core.CfnOutput(self, "LoadBalancerDNS", export_name="LoadBalancerDNS", value=Zach_LB.load_balancer_dns_name)

  def _add_autoscaling_group(
    self,
    vpc: ec2.Vpc,
    public_subnet,
    security_group: ec2.SecurityGroup,
    key_name: str
  ) -> autoscaling.AutoScalingGroup:
    """
    Add autoscaling group for running ec2 instance automatically
    """
    Zach_Ec2_InstanceImage = ec2.GenericLinuxImage(ami_map={"ap-southeast-1":"ami-048a01c78f7bae4aa"})
    ZachInitInstall=ec2.UserData.for_linux()
    ZachInitInstall.add_commands("yum install -y psmisc nginx")
    group = autoscaling.AutoScalingGroup(
      self,
      'zach-autoscale',
      vpc=vpc,
      instance_type=ec2.InstanceType.of(ec2.InstanceClass.BURSTABLE2, ec2.InstanceSize.MICRO),
      machine_image=Zach_Ec2_InstanceImage,
      max_capacity=2,
      vpc_subnets=public_subnet,
      associate_public_ip_address=True,
      key_name=key_name,
      user_data=ec2.UserData.add_commands(self,"yum install -y psmisc nginx")
    )
    group.add_security_group(security_group)
    core.CfnOutput(self, "ASG-GROUP-ARN", export_name="ASG-GROUP-ARN", value=group.auto_scaling_group_arn)
    core.CfnOutput(self, "ASG-GROUP", export_name="ASG-GROUP", value=group.auto_scaling_group_name)
    return group