#!/bin/bash

filename=svclist.tmp
stagelist=(sit uat prd)
> tsjinrong.conf

curl http://172.20.1.141:28080/v1/catalog/services -o $filename
for project in `cat $filename| jq 'keys' | jq .[] | cut -d "\""  -f 2`
do
for stage in ${stagelist[@]}
do
logpath=`[[ $stage -eq "prd" ]] && "/data/tsjinrong/prd-logs" || "/data/tsjinrong/logs"`
if [[ `cat $filename | jq .sms | grep $stage | wc -l` == 1 ]];
then
echo '''
    <source>
      type tail
      multiline_flush_interval 5s
      time_format %m%d %H:%M:%S.%N
      path '''$logpath/$project'''/log.json
      pos_file '''$logpath/$project-$stage'''.pos
      tag suncash-'''$project-$stage'''
      <pattern>
        format json
        time_key time
        time_format %Y-%m-%dT%H:%M:%S.%NZ
      </pattern>
    </source>
''' >> tsjinrong.conf
fi
done
done
cat fluentd-es-configmap.yaml > fluentd-collector.yaml
cat tsjinrong.conf >> fluentd-collector.yaml
echo '''
 
metadata:
  name: fluentd-es-config-v0.1.1
  namespace: kube-system
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
''' >> fluentd-collector.yaml

kubectl apply -f fluentd-collector.yaml
