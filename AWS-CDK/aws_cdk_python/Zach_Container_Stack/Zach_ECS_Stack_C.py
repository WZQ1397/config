# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-28 17:08

from aws_cdk import core, aws_ec2 as ec2 , aws_ecs as ecs,aws_elasticloadbalancingv2 as elb, aws_ecs_patterns as ecs_patterns
class Zach_ECS_Stack_C(core.Stack):

  def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
    super().__init__(scope, id, **kwargs)

    ZachECSName,EC2_SIZE,ZachTaskList,AppendHostFile,ENV_VARS=self.TaskVaribles
    LB_TYPE = "Network"
    vpc = ec2.Vpc(
      self, ZachECSName + "Vpc",
      max_azs=1
    )

    cluster = ecs.Cluster(
      self, ZachECSName + "Cluster",
      vpc=vpc
    )

    ZachECSNodeName = ZachECSName.replace("_","-") + "-Node-1"
    cluster.add_capacity(id=ZachECSNodeName,
                         instance_type=ec2.InstanceType(EC2_SIZE))
    print(vpc.vpc_id)
    self.CreateSVC(ZachTaskList,ZachECSNodeName,cluster,vpc,AppendHostFile,ENV_VARS,LB_TYPE)


  @property
  def TaskVaribles(self):
    ZachECSName = self.__class__.__name__
    EC2_SIZE = "t3a.micro"
    ZachTaskList = {
      'web-1':
        {
          "image": "nginx:latest",
          "num": 2,
          "port": 80
        },
      'web-2': {
        "image": "flask:latest",
        "num": 1,
        "port": 5000
      }
    }
    AppendHostFile = {"ZachELK":"172.10.10.28" , "ZachEMR":"172.10.101.10"}
    ENV_VARS = {"ECS_ENV": "Prod", "SVC_TYPE": "Web"}
    return ZachECSName,EC2_SIZE,ZachTaskList,AppendHostFile,ENV_VARS

  def CreateSVC(self,ZachTaskList,ZachECSNodeName,cluster,vpc,AppendHostFile,ENV_VARS,choice="ELB"):
    for TaskName, TaskValue in ZachTaskList.items():
      ZachTaskDef = ecs.TaskDefinition(self, id=ZachECSNodeName + "-" + TaskName,compatibility=ecs.Compatibility.EC2,network_mode=ecs.NetworkMode.AWS_VPC)
      core.CfnOutput(self, id=TaskName + "-ARN", value=ZachTaskDef.task_definition_arn)
      for num in range(TaskValue.get("num", 1)):
        container = ZachTaskDef.add_container(id=ZachECSNodeName + "-" + TaskName + str(num), cpu=1, memory_limit_mib=512,
                                  memory_reservation_mib=256, readonly_root_filesystem=True,
                                  working_directory="/data/web", user='web',
                                  health_check=ecs.HealthCheck(command=["ping 127.0.0.1"],
                                                               interval=core.Duration.seconds(30), retries=5,
                                                               start_period=core.Duration.minutes(1),
                                                               timeout=core.Duration.seconds(10)),
                                  hostname=ZachECSNodeName + "-" + TaskName, extra_hosts=AppendHostFile,
                                  environment=ENV_VARS, docker_labels=ENV_VARS,
                                  image=ecs.ContainerImage.from_registry(TaskValue.get("image", "nginx:latest")),
                                  logging=ecs.LogDrivers.fluentd())
        port_mapping = ecs.PortMapping(
          container_port=TaskValue.get("port", 80),
          host_port=TaskValue.get("port", 80),
          protocol=ecs.Protocol.TCP
        )
        container.add_port_mappings(port_mapping)

        core.CfnOutput(self, id=container.container_name + "-ContainPort", value=str(container.container_port))
        core.CfnOutput(self, id=container.container_name + "-MemLimit", value=str(container.memory_limit_specified))
        core.CfnOutput(self, id=container.container_name + "-HostPort", value=str(port_mapping.host_port))

      svc = self.ELB_SVC(ZachECSNodeName,TaskName,ZachTaskDef,cluster,vpc) if choice=="ELB" else self.NetworkLBSVC(ZachECSNodeName,TaskName,cluster)


    core.CfnOutput(self, id=ZachECSNodeName + "-ARN", value=cluster.cluster_arn)
    core.CfnOutput(self, id=ZachECSNodeName + "-VPCID", value=str(cluster.vpc.vpc_id))
    core.CfnOutput(self, id=ZachECSNodeName + "-VPCZone", value=str(cluster.vpc.availability_zones))

  def ELB_SVC(self,ZachECSNodeName,TaskName,ZachTaskDef,cluster,vpc):
    ecs_service = ecs.Ec2Service(self, id=ZachECSNodeName + TaskName,
                   task_definition=ZachTaskDef,
                   cluster=cluster,
                   desired_count=2,
                   security_group=self.VPC_SG(TaskName, vpc),
                   assign_public_ip=True,
                   # health_check_grace_period=core.Duration.seconds(30), # Health check grace period is only valid for services configured to use load balancers
                   service_name=ZachECSNodeName + TaskName)

    # Create ALB
    lb = elb.ApplicationLoadBalancer(
      self, ZachECSNodeName + TaskName + "-LB",
      vpc=vpc,
      internet_facing=True
    )
    listener = lb.add_listener(
      ZachECSNodeName + TaskName+ "PublicListener",
      port=80,
      open=True
    )

    health_check = elb.HealthCheck(
      interval=core.Duration.seconds(60),
      path="/health",
      timeout=core.Duration.seconds(5)
    )

    # Attach ALB to ECS Service
    listener.add_targets(
      ZachECSNodeName + TaskName+"-ECS",
      port=80,
      targets=[ecs_service],
      health_check=health_check,
    )

    core.CfnOutput(
      self, ZachECSNodeName + TaskName+ "-LoadBalancerDNS",
      value=lb.load_balancer_dns_name
    )
    core.CfnOutput(self, id=ZachECSNodeName + TaskName + "-ServiceName", value=ecs_service.service.service_name)
    core.CfnOutput(self, id=ZachECSNodeName + TaskName + "-ServiceARN", value=ecs_service.service.service_arn)
    return ecs_service

  def NetworkLBSVC(self,ZachECSNodeName,TaskName,cluster):
    ecs_service = ecs_patterns.NetworkLoadBalancedEc2Service(
      self, id=TaskName,
      cluster=cluster,
      memory_limit_mib=512,
      task_image_options=ecs_patterns.NetworkLoadBalancedTaskImageOptions(image=ecs.ContainerImage.from_registry("amazon/amazon-ecs-sample"))
    )
    core.CfnOutput(
      self, ZachECSNodeName + TaskName + "-LoadBalancerDNS",
      value=ecs_service.load_balancer.load_balancer_dns_name
    )
    core.CfnOutput(self, id=ZachECSNodeName + TaskName + "-ServiceName", value=ecs_service.service.service_name)
    core.CfnOutput(self, id=ZachECSNodeName + TaskName + "-ServiceARN", value=ecs_service.service.service_arn)
    return ecs_service

  def VPC_SG(self,TaskName,vpc):
    security_group = ec2.SecurityGroup(
      self, id=TaskName,
      vpc=vpc,
      allow_all_outbound=False
    )
    security_group.add_ingress_rule(
      ec2.Peer.any_ipv4(),
      ec2.Port.tcp(80)
    )
    security_group.add_ingress_rule(
      ec2.Peer.any_ipv4(),
      ec2.Port.tcp(5000)
    )
    return security_group