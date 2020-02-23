# -*- coding: utf-8 -*-
# Author: Zach.Wang
# @Time  : 2019-10-22 17:48

from aws_cdk import aws_lambda as lambda_,core


class PyStack(core.Stack):

    def __init__(self, app: core.App, id: str, **kwargs) -> None:
        super().__init__(app, id)

        with open('aws_cdk_python/Zach_Lambda_Stack/lambda_handler.py', encoding="utf8") as fp:
            handler_code = fp.read()

            lambdaFn = lambda_.Function(
                self,
                "InlineLambda",
                code=lambda_.InlineCode(handler_code),
                handler="index.main",
                timeout=core.Duration.seconds(2),
                runtime=lambda_.Runtime.PYTHON_3_7
            )

app = core.App()
PyStack(app, "cdk-py-lambda-cdk")
app.synth()
