#!/bin/bash
for x in `kubectl exec -it tsjr-consul-dev-sg-1-547f8dcc96-nd9v9  -- consul kv export | grep key | awk -F "\"" '{print $4}' | grep sit`
do
kubectl exec -it tsjr-consul-dev-sg-1-547f8dcc96-nd9v9  -- consul kv get $x | sed 's#redis-sit#redis-prd#g' | sed 's#ZACH.WANG#fSAD98EWQ#g'| sed 's#-dev#-prd#g'| sed 's#alisql-cluster-sit#suncash-prd-inner.mysql.singapore.rds.aliyuncs.com#g' | sed 's#9mx9dolPI7L1AzUA#3xA1suGMNYaAAcdn#g' | kubectl exec -it tsjr-consul-dev-sg-1-547f8dcc96-nd9v9  -- consul kv put `echo $x | sed 's#sit#prd#g'` -
done
