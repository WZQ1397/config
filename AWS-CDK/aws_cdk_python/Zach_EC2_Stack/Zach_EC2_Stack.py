from aws_cdk import core,aws_ec2 as ec2
class Zach_EC2_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        self._create_instance(2)

    def _create_instance(self,num):

        InitData = open("aws_cdk_python/Zach_EC2_Stack/init.sh", "rb").read()
        ZachInitInstall=ec2.UserData.for_linux()
        ZachInitInstall.add_commands(str(InitData,encoding='UTF-8'))
        Zach_Ec2_InstanceImage = ec2.GenericLinuxImage(ami_map={"ap-southeast-1":"ami-048a01c78f7bae4aa"})
        Zach_Ec2_Instance_Key="aws-sg-root"

        try:
            TypeClass=ec2.InstanceClass.BURSTABLE2
            TypeSize=ec2.InstanceSize.MICRO
            Zach_Ec2_InstanceType=ec2.InstanceType.of(TypeClass,TypeSize)
        except Exception as e:
            Zach_Ec2_InstanceType=ec2.InstanceType(instance_type_identifier="t2.micro")

        vpc = ec2.Vpc.from_lookup(self,id="Zach_VPC_Stack_A",vpc_id="vpc-01e73b4b5c6f9f98a")
        for ids in range(num):
            ZachSequence = self.__class__.__name__+"-"+str(ids).zfill(5)
            Zach_Ec2_Instance=ec2.Instance(self,id=ZachSequence,instance_name=ZachSequence,
                                           instance_type=Zach_Ec2_InstanceType,
                                           machine_image=Zach_Ec2_InstanceImage,
                                           vpc=vpc,
                                           vpc_subnets=ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC),
                                           key_name=Zach_Ec2_Instance_Key,
                                           user_data=ZachInitInstall)
            Zach_Ec2_Instance.add_security_group(ec2.SecurityGroup.from_security_group_id(self,id=ZachSequence+"SSH",
                                                                                          security_group_id="sg-02fb046cddb80deca"))
            Zach_Ec2_Instance.add_security_group(ec2.SecurityGroup.from_security_group_id(self, id=ZachSequence+"WEB",
                                                                                          security_group_id="sg-07a1d71bba92f38ca"))
            Zach_Ec2_Instance_Tag=[]
            Zach_Ec2_Instance_Tag.append(core.Tag.add(self,"OStype","Linux"))
            Zach_Ec2_Instance_Tag.append(core.Tag.add(self,"K8S","False"))
            Zach_Ec2_Instance_Tag.append(core.Tag.add(self,"Publish","True"))

            core.CfnOutput(self, "InstanceID-"+str(ids), value=Zach_Ec2_Instance.instance_id)
            core.CfnOutput(self, "InstancePubIP-"+str(ids), value=Zach_Ec2_Instance.instance_public_ip)
            core.CfnOutput(self, "InstancePrivIP-"+str(ids),value=Zach_Ec2_Instance.instance_private_ip)
            core.CfnOutput(self, "InstanceOS-"+str(ids), value=Zach_Ec2_Instance.os_type.value)
            core.CfnOutput(self, "InstanceRole-"+str(ids), value=Zach_Ec2_Instance.role.role_arn)
            core.CfnOutput(self, "InstanceBindSG-"+str(ids),value=str(Zach_Ec2_Instance.connections.security_groups))
            core.CfnOutput(self, "InstanceLogicID-"+str(ids), value=Zach_Ec2_Instance.instance.logical_id)


