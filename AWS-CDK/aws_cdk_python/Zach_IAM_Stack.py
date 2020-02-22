# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-21 10:57

from aws_cdk import core, aws_iam as iam
import os,uuid,random
from datetime import date
class Zach_IAM_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)
        ZachUserDefinedPolicyManagerAction = [
                "iam:GenerateCredentialReport",
                "iam:GetAccountPasswordPolicy",
                "iam:GetServiceLastAccessedDetailsWithEntities",
                "iam:ListServerCertificates",
                "iam:GenerateServiceLastAccessedDetails",
                "iam:ListPoliciesGrantingServiceAccess",
                "iam:GetServiceLastAccessedDetails",
                "iam:ListVirtualMFADevices",
                "iam:GetOrganizationsAccessReport",
                "iam:SimulateCustomPolicy",
                "config:*",
                "iam:GetAccountAuthorizationDetails",
                "iam:GetCredentialReport",
                "iam:ListPolicies",
                "cloudtrail:LookupEvents",
                "iam:ListSAMLProviders",
                "iam:ListRoles",
                "cloudtrail:DescribeTrails",
                "iam:GetContextKeysForCustomPolicy",
                "iam:ListOpenIDConnectProviders",
                "cloudwatch:*",
                "cloudtrail:ListPublicKeys",
                "iam:ListAccountAliases",
                "iam:ListUsers",
                "iam:ListGroups",
                "iam:GetAccountSummary"
            ]

        ZachUserDefinedPolicyManagerStatement = iam.PolicyStatement(resources=['*'] ,actions=ZachUserDefinedPolicyManagerAction,effect=iam.Effect.ALLOW)
        Zach_Init_Privilege_List = {
          "RDSFullPrivilege":"AmazonRDSDataFullAccess",
          "RDSReadPrivilege":"AmazonRDSReadOnlyAccess",
          "EC2FullPrivilege":"AmazonEC2FullAccess",
          "EC2ReadPrivilege": "AmazonEC2ReadOnlyAccess",
          "CachePrivilege": "AmazonElastiCacheFullAccess"
        }

        IAM_ACCOUNT_LIST = {
          "Zach_AWS_DEV" :
            {
              "Basic": [Zach_Init_Privilege_List.get("RDSReadPrivilege")],
              "Users":{
                "Zach_AWS_DEV_Depart_A": [],
                "Zach_AWS_DEV_Depart_B": [],
                "Zach_AWS_DEV_Depart_C": []
              }
            },
          "Zach_AWS_OPS":
            {
              "Basic": [Zach_Init_Privilege_List.get("RDSReadPrivilege"),Zach_Init_Privilege_List.get("EC2ReadPrivilege")],
              "Users": {
                "Zach_AWS_OPS_A": [],
                "Zach_AWS_OPS_B": [Zach_Init_Privilege_List.get("EC2FullPrivilege")]
              }
          },
          "Zach_AWS_DBA": {
            "Basic": [Zach_Init_Privilege_List.get("RDSFullPrivilege")],
            "Users": {
              "Zach_AWS_DBA":[Zach_Init_Privilege_List.get("EC2ReadPrivilege"),Zach_Init_Privilege_List.get("CachePrivilege")]
            }
          },
          "Zach_AWS_Manager": {
            "Basic": [],
            "Users": {
              "Zach_AWS_Manager": []
            }
          }
        }

        IAM_BASIC_POLICY = [iam.ManagedPolicy.from_aws_managed_policy_name("AmazonS3ReadOnlyAccess")]

        IAM_ACCOUNT = self.node.try_get_context("account") or os.getenv('account') or '098380756085'

        core.CfnOutput(self, id="IAM_ACCOUNT: ", value=IAM_ACCOUNT)
        for RoleName,RolePrivilege in Zach_Init_Privilege_List.items():
          Zach_IAM_Role = iam.Role(self,id="Zach_"+RoleName,
                                   role_name="Zach_"+RoleName,
                                   assumed_by=iam.AccountPrincipal(IAM_ACCOUNT),
                                   max_session_duration=core.Duration.hours(12))
          Zach_IAM_Role.add_managed_policy(iam.ManagedPolicy.from_aws_managed_policy_name(RolePrivilege))
          core.CfnOutput(self, id=RoleName, value=Zach_IAM_Role.role_id)

        for Group,Statement in IAM_ACCOUNT_LIST.items():
          Zach_Group = iam.Group(self,id="Zach_AWS_"+Group+"_Group",group_name="Zach_AWS_"+Group+"_Group")
          for BasicPriv in Statement.get("Basic"):
              Zach_Group.add_managed_policy(iam.ManagedPolicy.from_aws_managed_policy_name(BasicPriv))
          if Group in ["Zach_AWS_Manager"]:
              Zach_Group.attach_inline_policy(policy=iam.Policy(self,id="UserDefined"+Group,policy_name="UserDefined"+Group,statements=[ZachUserDefinedPolicyManagerStatement]))
          randid=str(random.randint(10000,99999))
          core.CfnOutput(self, id="GroupName"+randid, value=Zach_Group.group_name)
          core.CfnOutput(self, id="GroupARN"+randid, value=Zach_Group.group_arn)
          core.CfnOutput(self, id="GroupRoleAction"+randid, value=Zach_Group.assume_role_action)
          for User in Statement.get("Users"):
            UserPasswordGenerator = str(uuid.uuid4())[25:50]
            UserCreated = iam.User(self,id=User,managed_policies=IAM_BASIC_POLICY,password=core.SecretValue(value=UserPasswordGenerator),password_reset_required=False)
            UserCreated.add_to_group(iam.Group.from_group_arn(self,id=User+str(date.today()),group_arn=Zach_Group.group_arn))
            core.CfnOutput(self,id=User+str(random.randint(10000,99999)),value=UserCreated.user_name)
            core.CfnOutput(self,id=User+"Password: ",value=UserPasswordGenerator)
