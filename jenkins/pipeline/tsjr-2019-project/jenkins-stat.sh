#!/bin/bash
job_name=$1
job_seq=$2
stage=$3
deploy=$4
function dingding(){
curl 'https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxxxxxxxxxxxx'    -H 'Content-Type: application/json'  -d '{
     "msgtype": "text",
     "text": {
         "content": "'"第${job_seq}次部署-${job_name} 状态: $status"'"
     },
     "at": {
         "atMobiles": [
             ""
         ],
         "isAtAll": false
     }
 }'
}
if [[ $deploy -eq 0 ]];
then
cd /data2/jenkins-data/workspace/"$job_name"
ls -la
/data/jenkins-tools/mvn3/bin/mvn -U -e clean package -Dmaven.test.skip=true -P "$stage"
chown -R 1000.1000 .
fi

if [[ $? -ne 0 ]];
then
status="Build failed!"
dingding
exit 255
else
if [[ $deploy -eq 1 ]];
then
status=$(curl http://xxxxxxxxxxx:8081/api/json?pretty=true --user devops:tsjinrong | jq .jobs[] | grep -C 3 http://xxxxxxxxxxxx:8081/job/"$job_name"/ | jq 'if .color|length>8 then "Deploying!" else "Deploy Failed!" end' | cut -d '"' -f 2)
dingding
fi
fi
