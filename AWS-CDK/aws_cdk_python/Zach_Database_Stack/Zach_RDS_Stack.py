# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-21 10:52

from aws_cdk import core, aws_ec2 as ec2 ,aws_rds as rds, aws_logs, aws_iam as iam,aws_cloudwatch as cw


class Zach_RDS_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ZachDBInstanceClass= ec2.InstanceType.of(ec2.InstanceClass.BURSTABLE2,ec2.InstanceSize.MICRO)
        # TODO NEED MUTI SUBNET OF VPC
        ZachDBInstanceBelongVpc= ec2.Vpc.from_lookup(self,id="ZachDBInstanceBelongVpc",vpc_id="vpc-01e73b4b5c6f9f98a")
        ZachDBInstanceSubnet = ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC)
        ZachDBInstanceRole=iam.Role.from_role_arn(self,id="ZachRDSRole",role_arn="arn:aws:iam::098380756085:role/Zach_RDSFullPrivilege")
        mode = "HA"

        ZachDBInstance= rds.DatabaseInstance(self,id="ZachDB-A",database_name="ZachDB",
                                             instance_identifier="ZachDB",
                                             master_username="zach",
                                             master_user_password=core.SecretValue(value="tsjr123!"),
                                             instance_class=ZachDBInstanceClass,
                                             engine=rds.DatabaseInstanceEngine.MYSQL,
                                             engine_version="5.7.22",
                                             auto_minor_version_upgrade=True,
                                             storage_type=rds.StorageType.STANDARD,
                                             allocated_storage=20,
                                             vpc=ZachDBInstanceBelongVpc,
                                             vpc_placement=ZachDBInstanceSubnet,
                                             port=33306,
                                             preferred_backup_window="17:00-22:00",  # UTC time
                                             backup_retention=core.Duration.days(35),
                                             deletion_protection=True,  # TODO IF YOU WANT TO DELETE DB , YOU NEED TO DISABLE THIS FIRST
                                             cloudwatch_logs_retention=aws_logs.RetentionDays.ONE_MONTH,
                                             cloudwatch_logs_retention_role=ZachDBInstanceRole,
                                             multi_az=False)

        ZachDBInstance.metric_database_connections(color="blue",label="ZachDB-A",period=core.Duration.minutes(2))
        ZachDB_CPU_Metric = ZachDBInstance.metric_cpu_utilization(color="red",label="CPU Util")
        ZachDB_RAM_Metric = ZachDBInstance.metric_freeable_memory(color="green",label="Memory Free")
        ZachDB_Disk_Metric = ZachDBInstance.metric_free_storage_space(color="purple",label="DiskSpace Free")
        # cw.Metric(metric_name="ZachDB-A",namespace="ZachDB-A")

        core.CfnOutput(self,id="ZachDB-A-ARN",value=ZachDBInstance.instance_arn)
        core.CfnOutput(self,id="ZachDB-A-VPC",value=ZachDBInstance.vpc.vpc_id)
        core.CfnOutput(self,id="ZachDB-A-ADDRESS",value=ZachDBInstance.db_instance_endpoint_address)
        core.CfnOutput(self,id="ZachDB-A-PORT",value=ZachDBInstance.db_instance_endpoint_port)

        if mode == "HA":
            ZachDBInstanceRead= rds.DatabaseInstanceReadReplica(self,id="ZachDB-A-read",database_name="ZachDB-A-read",
                                                 source_database_instance=ZachDBInstance,
                                                 master_user_password=core.SecretValue(value="tsjr123!"),
                                                 instance_class=ZachDBInstanceClass,
                                                 engine=rds.DatabaseInstanceEngine.MYSQL,
                                                 engine_version="5.7.22",
                                                 auto_minor_version_upgrade=True,
                                                 storage_type=rds.StorageType.STANDARD,
                                                 allocated_storage=20,
                                                 vpc=ZachDBInstanceBelongVpc,
                                                 vpc_placement=ZachDBInstanceSubnet,
                                                 port=33306,
                                                 preferred_backup_window="17:00-22:00",  # UTC time
                                                 backup_retention=core.Duration.days(35),
                                                 deletion_protection=True,
                                                 cloudwatch_logs_retention=aws_logs.RetentionDays.ONE_MONTH,
                                                 cloudwatch_logs_retention_role=ZachDBInstanceRole,
                                                 multi_az=False)

            core.CfnOutput(self,id="ZachDB-A-read-ARN",value=ZachDBInstanceRead.instance_arn)
            core.CfnOutput(self,id="ZachDB-A-read-VPC",value=ZachDBInstanceRead.vpc.vpc_id)
            core.CfnOutput(self,id="ZachDB-A-read-ADDRESS",value=ZachDBInstanceRead.db_instance_endpoint_address)
            core.CfnOutput(self,id="ZachDB-A-read-PORT",value=ZachDBInstanceRead.db_instance_endpoint_port)


