#!/bin/bash

filename=svclist.tmp
stagelist=(sit online)
> tsjinrong.conf

curl http://172.20.1.141:28080/v1/catalog/services -o $filename
for project in `cat $filename| jq 'keys' | jq .[] | cut -d "\""  -f 2 | grep -v [[:alpha:]]-[[:alpha:]]`
do
for stage in ${stagelist[@]}
do
if [[ `cat $filename | jq ".$project" | grep $stage | wc -l` == 1 ]];
then
if [[ $stage ==  "online" ]];
then
  logpath="/data/tsjinrong/prd-logs"
else
  logpath="/data/tsjinrong/logs"
fi
echo '''
    <source>
      type tail
      multiline_flush_interval 5s
      time_format %m%d %H:%M:%S.%N
      path '''$logpath/$project'''/log.json
      pos_file '''$logpath/$project-$stage'''.pos
      tag suncash-'''$project-$stage'''
      format json
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
kubectl delete -f fluentd-es-ds.yaml
sleep 10
kubectl get ds --namespace kube-system
kubectl apply -f fluentd-es-ds.yaml
