#!/bin/bash
service=$1
BUILD_NUM=$2
oriname=$3
stage=$4
JOB_NAME=$5
# http://172.16.48.111:8081/view/suncash/job/suncash-manage-center-sit/6/execution/node/3/ws/index.html
curl -o /tsjr-data/nginx-data/web/$stage/$oriname http://222.66.149.30:8081/job/$JOB_NAME/$BUILD_NUM/execution/node/3/ws/$oriname -u devops:tsjinrong
cd /tsjr-data/nginx-data/web/$stage
#rm -rf $service
if [ ! -d $service ];
then
   mkdir $service
fi
tar zxvf $oriname
mv $service $service-`date +%s`
mv data2/jenkins-data/workspace/$JOB_NAME/dist .
mv dist $service