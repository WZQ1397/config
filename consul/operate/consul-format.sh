#!/bin/bash
for x in `/root/consul kv export | grep key | awk -F "\"" '{print $4}' | grep sit`
do
./consul kv get $x | sed 's/alisql-cluster-sit/172.16.48.111/g' | sed 's/username: suncash/username: root/g' | sed 's/9mx9dolPI7L1AzUA/tsjinrong/g' | /root/consul kv put `echo $x | sed 's/sit/local/g'` -
done
