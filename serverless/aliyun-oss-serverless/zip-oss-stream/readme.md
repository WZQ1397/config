+ 在OSS上准备要打包的文件

把文件放在OSS上面一个目录下面
触发函数(通过API网关)

+ 使用curl命令直接调用函数
'''
curl -v -L -o /tmp/my.zip -H "Content-Type: application/json" -d @./event.json \
{apigateway-domain}-cn-shanghai.alicloudapi.com/zip?redirect=true
'''