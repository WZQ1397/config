#!/bin/bash
service=$1
svcport=$2
stage=$3
oriname=$4
deployYmlDir=bin
jar_name=tsjr-$service-$svcport-$stage
ymlfile=bin/$jar_name.yml
tmplfile=deploy-template.yml
if [[ ! -d $deployYmlDir ]];
then
        mkdir $deployYmlDir
fi
cat $tmplfile > $ymlfile
sed -i "s/\$service/$service/g" $ymlfile
sed -i "s/\$svcport/$svcport/g" $ymlfile
sed -i "s/\$stage/$stage/g" $ymlfile
sed -i "s/\$jar_name/$jar_name/g" $ymlfile

mv -bv $oriname $jar_name.jar

kubectl create -f $ymlfile --save-config --record
i=0
status=UNKNOWN
while [ $i -le 5 ] && $status != "Running"
do
sleep 5
[[ `kubectl get pods | grep $jar_name | awk '{print $3}' | tail -1` == "Running" ]] && echo "start success" || echo "running failed"
done