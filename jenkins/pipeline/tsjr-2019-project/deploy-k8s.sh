#!/bin/bash
service=$1
svcport=$2
stage=$3
oriname=$4
out_port=$5
deployYmlDir=bin
jar_name=tsjr-$service-$svcport
ymlfile=bin/$jar_name.yml
tmplfile=deploy-template.yml
zach_home=/tsjr-data/deploy-java
BUILD_NUM=$6

cd $zach_home/generator
chmod +x *

if [[ ! -d $deployYmlDir ]];
then
        mkdir $deployYmlDir
fi

cat deploy/$tmplfile > $ymlfile
sed -i "s/\$service/$service/g" $ymlfile
sed -i "s/\$svcport/$svcport/g" $ymlfile
sed -i "s/\$stage/$stage/g" $ymlfile
sed -i "s/\$jar_name/$jar_name/g" $ymlfile
sed -i "s/\$out_port/$out_port/g" $ymlfile
ns=default
if [ $stage == "online" -o  $stage == "prd" ];
then
#  ns="suncash-prd"
  sed -i "s#path: /data/tsjinrong/logs#path: /data/tsjinrong/prd-logs#g" $ymlfile
fi

kubectl delete deployment  --namespace=$ns $jar_name && echo deleteing... || echo notexist
sleep 10

rm -rf $zach_home/$oriname.jar~
if [[ -f $zach_home/$jar_name.jar ]];
then
  mv $zach_home/$jar_name.jar $zach_home/$jar_name.jar~
fi
curl -o $zach_home/$oriname http://xxxxxxxxxxxxx:8081/job/$service/$BUILD_NUM/execution/node/3/ws/target/$oriname -u xxxx:xxxx
mv $zach_home/$oriname $zach_home/$jar_name.jar

kubectl create --namespace=$ns -f $ymlfile --save-config --record
i=0
status="UNKNOWN"
while [ $i -le 5 ]  && [ $status != "Running" ]
do
sleep 5
[[ `kubectl get pods --namespace=$ns | grep $jar_name-$svcport | awk '{print $3}' | tail -1` == "Running" ]] && echo "start success" || echo "running failed"
i=$(($i+1))
done

kubectl get deployment --namespace=$ns $jar_name
