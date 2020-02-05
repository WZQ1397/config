# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-11-04 14:37

from aws_cdk import core, aws_ecr as ecr, aws_iam as iam,aws_events as event ,aws_events_targets as eventarget , aws_sns as sns ,aws_sns_subscriptions as sns_sub
import os

class Zach_ECR_Stack_A(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        ZachRepositoryName = self.__class__.__name__
        ZachRepository = ecr.Repository(self,id=ZachRepositoryName)
        ZachRepository.add_lifecycle_rule(max_image_count=100,
                                          rule_priority=50,
                                          tag_status=ecr.TagStatus.TAGGED,
                                          tag_prefix_list=['sit','uat','dev'])
        ZachRepository.add_lifecycle_rule(max_image_age=core.Duration.days(720),
                                          rule_priority=100)
        ZachRepository.grant_pull_push(
          iam.Role.from_role_arn(self,
                                 id="EC2FullPrivilege",
                                 role_arn="arn:aws:iam::098380756085:role/Zach_EC2FullPrivilege"))
        ZachRepository.grant_pull(
          iam.Role.from_role_arn(self,
                                 id="EC2ReadPrivilege",
                                 role_arn="arn:aws:iam::098380756085:role/Zach_EC2ReadPrivilege"))
        ZachRepositoryEvent = ZachRepository.on_cloud_trail_event(id="DockerTrail",
                                            event_pattern=event.EventPattern(
                                              account=[self.node.try_get_context("account") or os.getenv('account') or '098380756085'],
                                              region=['ap-southeast-1']))

        ZachSNStopic=self.SnsExporter(ZachRepositoryName)
        ZachRepositoryEvent.add_target(eventarget.SnsTopic(topic=ZachSNStopic))

        core.CfnOutput(self, id=ZachRepositoryName+"ARN", value=ZachRepository.repository_arn)
        core.CfnOutput(self, id=ZachRepositoryName+"URI", value=ZachRepository.repository_uri)
        core.CfnOutput(self, id=ZachRepositoryName+"RuleARN", value=ZachRepositoryEvent.rule_arn)
        core.CfnOutput(self, id=ZachRepositoryName+"RuleName", value=ZachRepositoryEvent.rule_name)
        core.CfnOutput(self, id=ZachRepositoryName+"TopicARN", value=ZachSNStopic.topic_arn)
        core.CfnOutput(self, id=ZachRepositoryName+"TopicName", value=ZachSNStopic.topic_name)

    def SnsExporter(self,ZachRepositoryName):
      ZachSNStopic = sns.Topic(self,
                               id=ZachRepositoryName + "SNS",
                               display_name=ZachRepositoryName + "SNS",
                               topic_name=ZachRepositoryName + "SNS")
      ZachSNStopicFilterPolicy = sns.SubscriptionFilter

      ZachSNStopic.add_subscription(
        sns_sub.EmailSubscription(
          email_address="wangzhengqi@tsjinrong.cn",
          filter_policy={
            'status': ZachSNStopicFilterPolicy.string_filter(whitelist=['delete', 'not exist'])
          }
        ))

      return ZachSNStopic
