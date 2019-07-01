#!/bin/bash
for x in `curl http://172.16.48.111:8500/v1/agent/services | jq 'keys' | jq .[] | cut -d '"' -f 2`
do 
curl -X PUT http://172.16.48.111:8500/v1/agent/service/deregister/$x
done

# 单独删除服务
# for x in `curl http://172.30.106.149:8500/v1/agent/services | jq 'keys' | jq .[] | cut -d '"' -f 2 | grep appro ` ; do curl -X PUT http://172.30.106.149:8500/v1/agent/service/deregister/$x; done
