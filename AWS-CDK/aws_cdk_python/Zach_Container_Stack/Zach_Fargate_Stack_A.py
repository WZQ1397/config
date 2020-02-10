# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-11-01 10:18


from aws_cdk import core, aws_ec2 as ec2, aws_ecs as ecs, aws_ecs_patterns as ecs_patterns


class Zach_Fargate_Stack_A(core.Stack):
  #TODO SOMETHING NOT EFFECT
  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)
    # Create VPC and Fargate Cluster
    # NOTE: Limit AZs to avoid reaching resource quotas
    ZachECSName, ZachTaskList, ENV_VARS = self.TaskVaribles
    vpc = ec2.Vpc(
      self, ZachECSName + "Vpc",
      max_azs=1
    )

    cluster = ecs.Cluster(
      self, ZachECSName + "Cluster",
      vpc=vpc
    )

    for k, v in ZachTaskList.items():
      self.FargateTasks(cluster, k, v, ENV_VARS)

  @property
  def TaskVaribles(self):
    ZachECSName = self.__class__.__name__
    ZachTaskList = {
      'web-1':
        {
          "image": "nginx:latest",
          "num": 2,
          "port": 80
        },
      # 'web-2': {
      #   "image": "flask:latest",
      #   "num": 1,
      #   "port": 5000
      # }
    }
    ENV_VARS = {"ECS_ENV": "Prod", "SVC_TYPE": "Web"}
    return ZachECSName, ZachTaskList, ENV_VARS

  def FargateTasks(self, cluster, svcname, svcvalue, env_var):
    fargate_service = ecs_patterns.NetworkLoadBalancedFargateService(
      self, "Fargate-" + svcname,
      cluster=cluster,
      task_image_options={
        'image': ecs.ContainerImage.from_registry(svcvalue['image']),
        'container_port': svcvalue.get('port', 80),
        'container_name': svcname,
        'enable_logging ': True,
        'environment': env_var,
        'secret': env_var,
      },

    )
    scaling = fargate_service.service.auto_scale_task_count(
      min_capacity=2,
      max_capacity=5,
    )
    scaling.scale_on_cpu_utilization(
      "CpuScaling" + svcname,
      policy_name="CpuScaling" + svcname,
      target_utilization_percent=10,
      scale_in_cooldown=core.Duration.seconds(60),
      scale_out_cooldown=core.Duration.seconds(60),
    )
    scaling.scale_on_memory_utilization(
      "MemoryScaling" + svcname,
      policy_name="MemoryScaling" + svcname,
      target_utilization_percent=600,
      scale_in_cooldown=core.Duration.seconds(60),
      scale_out_cooldown=core.Duration.seconds(60),
    )

    return self.FargateOutput(svcname, fargate_service)

  def FargateOutput(self, svcname, fargate_service):
    core.CfnOutput(
      self, "LoadBalancerDNS-" + svcname,
      value=fargate_service.load_balancer.load_balancer_dns_name
    )
    core.CfnOutput(
      self, "FargateSvcARN-" + svcname,
      value=fargate_service.service.service_arn
    )
    core.CfnOutput(
      self, "FargateSvcName-" + svcname,
      value=fargate_service.service.service_name
    )
    core.CfnOutput(
      self, "FargateClusterARN-" + svcname,
      value=fargate_service.service.cluster.cluster_arn
    )
    core.CfnOutput(
      self, "FargateSvcVPCID-" + svcname,
      value=fargate_service.cluster.vpc.vpc_id
    )
