# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-22 15:30

from aws_cdk import core, aws_backup as bk, aws_iam as iam


class Zach_AWSBackup_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        Zach_AWSBackupPlanName = self.__class__.__name__
        Zach_AWSBackup_Vault = bk.CfnBackupVault(self,id=Zach_AWSBackupPlanName,backup_vault_name=Zach_AWSBackupPlanName)
        Zach_AWSBackup_IAM_ROLE = "arn:aws:iam::098380756085:role/service-role/AWSBackupDefaultServiceRole"
        if Zach_AWSBackup_IAM_ROLE == "":
          IAM_ACCOUNT = self.node.try_get_context("account") or '098380756085'
          IAM_Princial = iam.CompositePrincipal(
            iam.ServicePrincipal("backup.amazonaws.com"),
            iam.AccountPrincipal(IAM_ACCOUNT),
            iam.ArnPrincipal("arn:aws:ec2:*")
          )
          Zach_AWSBackup_IAM_ROLE= iam.Role(self,id="Zach_"+Zach_AWSBackupPlanName,
                                   role_name="Zach_"+Zach_AWSBackupPlanName,
                                   assumed_by=IAM_Princial,
                                   max_session_duration=core.Duration.hours(6))

        # FIXME
        '''
        jsii.errors.JSIIError: Value did not match any type in union: Value did not match any type in union: Expected object reference, got [{"CompletionWindowMinutes":30,"Lifecycle":{"DeleteAfterDays":90,"MoveToColdStorageAfterDays":28},"RuleName":"Zach_AWSBackup_Stack_A"
,"ScheduleExpression":"cron(0 5 ? * * *)","StartWindowMinutes":480,"TargetBackupVault":"Zach_AWSBackup_Stack_A"}],Value did not match any type in union: Expected object reference, got {"CompletionWindowMinutes":30,"Lifecycle":{"DeleteAfterDays":90,"MoveToColdStorag
eAfterDays":28},"RuleName":"Zach_AWSBackup_Stack_A","ScheduleExpression":"cron(0 5 ? * * *)","StartWindowMinutes":480,"TargetBackupVault":"Zach_AWSBackup_Stack_A"},Missing required properties for @aws-cdk/aws-backup.CfnBackupPlan.BackupRuleResourceTypeProperty: rul
eName,targetBackupVault,Expected object reference, got {"backupPlanName":"Zach_AWSBackup_Stack_A","backupPlanRule":[{"CompletionWindowMinutes":30,"Lifecycle":{"DeleteAfterDays":90,"MoveToColdStorageAfterDays":28},"RuleName":"Zach_AWSBackup_Stack_A","ScheduleExpress
ion":"cron(0 5 ? * * *)","StartWindowMinutes":480,"TargetBackupVault":"Zach_AWSBackup_Stack_A"}]}
        '''
        BackupPlanRule = [{
          "CompletionWindowMinutes" : 30,
          "Lifecycle" : {
            "DeleteAfterDays": 90,
            "MoveToColdStorageAfterDays": 28
          },
          "RuleName" : Zach_AWSBackupPlanName,
          "ScheduleExpression" : "cron(0 5 ? * * *)",
          "StartWindowMinutes" : 480,
          "TargetBackupVault" : Zach_AWSBackup_Vault.backup_vault_name
        }]
        Zach_AWSBackup = bk.CfnBackupPlan(self,id=Zach_AWSBackupPlanName,
                                          backup_plan={"backupPlanName": Zach_AWSBackupPlanName,"backupPlanRule": BackupPlanRule} )
        # , backup_plan_tags = ['dev', 'zach', Zach_AWSBackupPlanName]
        JobList = {
          "IamRoleArn" : "arn:aws:iam::098380756085:role/service-role/AWSBackupDefaultServiceRole",
          "ListOfTags" : [],
          "Resources" : ["arn:ap-southeast-1:ec2:ap-southeast-1a:098380756085:volume/vol-02a2664501c88e696"],
          "SelectionName" : Zach_AWSBackupPlanName+"EBS-00001"
        }
        Zach_AWSBackup_Job= bk.CfnBackupSelection(self,id=Zach_AWSBackupPlanName+"EBS-00001",backup_plan_id=Zach_AWSBackup.attr_backup_plan_id,
                                                  backup_selection=JobList)

        core.CfnOutput(self, "ZachAWSBackupID", value=Zach_AWSBackup.logical_id)
        core.CfnOutput(self, "ZachAWSBackupPlanID", value=Zach_AWSBackup.attr_backup_plan_id)
        core.CfnOutput(self, "ZachAWSBackupPlanARN", value=Zach_AWSBackup.attr_backup_plan_arn)
        core.CfnOutput(self, "ZachAWSBackupPlan", value=Zach_AWSBackup.backup_plan.to_string)
        core.CfnOutput(self, "ZachAWSBackupRoleARN", value=Zach_AWSBackup_IAM_ROLE.role_arn)
        core.CfnOutput(self, "ZachAWSBackupVaultARN", value=Zach_AWSBackup_Vault.attr_backup_vault_arn)
        core.CfnOutput(self, "ZachAWSBackupVaultName", value=Zach_AWSBackup_Vault.backup_vault_name)