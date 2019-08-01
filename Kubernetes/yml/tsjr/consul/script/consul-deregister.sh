#!/bin/bash
url="http://consul.k8s-dev-local.tsjinrong.top"
for x in `curl http://consul.k8s-dev-local.tsjinrong.top/v1/agent/services | jq 'keys' | jq .[] | cut -d '"' -f 2`
do
curl -X PUT http://consul.k8s-dev-local.tsjinrong.top/v1/agent/service/deregister/$x
done

# 单独删除服务
# for x in `curl http://172.30.106.149:8500/v1/agent/services | jq 'keys' | jq .[] | cut -d '"' -f 2 | grep appro ` ; do curl -X PUT http://172.30.106.149:8500/v1/agent/service/deregister/$x; done
