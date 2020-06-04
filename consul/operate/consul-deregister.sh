#!/bin/bash
consulAddr=172.30.197.185
for x in `curl http://$consulAddr:8500/v1/agent/checks | jq '.[] | select(.Status != "passing") | .CheckID' | awk -F ":" 'gsub(/"/,"",$0){print $NF}'`
do 
curl -X PUT http://$consulAddr:8500/v1/agent/service/deregister/$x
done

# 单独删除服务
# for x in `curl http://172.30.106.149:8500/v1/agent/services | jq 'keys' | jq .[] | cut -d '"' -f 2 | grep appro ` ; do curl -X PUT http://172.30.106.149:8500/v1/agent/service/deregister/$x; done
