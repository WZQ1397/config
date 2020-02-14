# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-22 13:35

from aws_cdk import core,aws_elasticache as cache, aws_ec2 as ec2

class Zach_Cache_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ZachCacheInstanceName = "Zach-Cache-Stack-A"
        ChooseCluster = False
        CacheType = "redis"  # redis or memcached
        NumCacheNodes = 2
        if not ChooseCluster:
            NumCacheNodes = 1
        EngineVersion = "4.0.10"
        Port=36379
        AZ_MODE = "cross-az" if ChooseCluster is True else "single-az"
        PreferredMaintenanceWindow = "sun:23:00-mon:01:30"

        # vpc= ec2.Vpc.from_lookup(self,id="Zach_VPC_Stack_A",vpc_id="vpc-03813ad7db2dc5cf2").vpc_id
        Cache_SG_VPC = ec2.Vpc.from_lookup(self, id="Zach_VPC_Stack_A", vpc_id="vpc-01e73b4b5c6f9f98a")
        Cache_SG = ec2.SecurityGroup(self, id=ZachCacheInstanceName + "-SG", allow_all_outbound=True, description="SG of Cache",
                                  security_group_name=ZachCacheInstanceName + "-SG", vpc=Cache_SG_VPC)
        FS_SG_IP_LIST = ["192.168.0.0/24", "10.0.1.0/24", "222.66.149.30/32"]
        for IP in FS_SG_IP_LIST:
            Cache_SG.add_ingress_rule(peer=ec2.Peer.ipv4(cidr_ip=IP), connection=ec2.Port.all_tcp())
            Cache_SG.add_ingress_rule(peer=ec2.Peer.ipv4(cidr_ip=IP), connection=ec2.Port.all_udp())

        ZachCacheSubnet = cache.CfnSubnetGroup(self,id="ZachCacheSubnet",
                                               subnet_ids=["subnet-047c4ab6ceb69f7a7","subnet-047c4ab6ceb69f7a7"],
                                               cache_subnet_group_name="ZachCacheSubnet",description="ZachCacheSubnet")
        ZachCacheInstance = cache.CfnCacheCluster(self,id=ZachCacheInstanceName+"-"+CacheType,
                                                  cluster_name=ZachCacheInstanceName+"-"+CacheType,
                                                  az_mode=AZ_MODE,
                                                  auto_minor_version_upgrade=True,
                                                  cache_node_type="cache.t2.micro",
                                                  num_cache_nodes=NumCacheNodes,
                                                  engine=CacheType,
                                                  engine_version=EngineVersion,
                                                  cache_subnet_group_name=ZachCacheSubnet.cache_subnet_group_name,
                                                  port=Port,
                                                  vpc_security_group_ids=[Cache_SG.security_group_id],
                                                  tags=[core.CfnTag(key="AZ-Mode",value=AZ_MODE),
                                                        core.CfnTag(key="Environment",value="Prod"),
                                                        core.CfnTag(key="Type",value=CacheType),
                                                        core.CfnTag(key="Cluster",value=str(ChooseCluster))])

        core.CfnOutput(self, "ZachCacheInstanceID", value=ZachCacheInstance.logical_id)
        core.CfnOutput(self, "ZachCacheInstanceName", value=ZachCacheInstance.cluster_name)
        core.CfnOutput(self, "ZachCacheInstanceADDRESS", value=ZachCacheInstance.attr_redis_endpoint_address)
        core.CfnOutput(self, "ZachCacheInstancePort", value=str(ZachCacheInstance.port))
        core.CfnOutput(self, "ZachCacheInstanceEngine", value=ZachCacheInstance.engine)
        core.CfnOutput(self, "ZachCacheInstanceEngineVer", value=ZachCacheInstance.engine_version)
        core.CfnOutput(self, "ZachCacheInstanceCounts", value=str(ZachCacheInstance.num_cache_nodes))
        core.CfnOutput(self, "ZachCacheInstancePortTags", value=str(ZachCacheInstance.tags))
