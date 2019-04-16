#!/bin/bash
service=$1
svcport=$2
oriname=$3
deployhome=/tsjr-data/deploy-java/
jar_name=tsjr-$service-$svcport
cd /tsjr-data/deploy-java
#if [[ ! -d $deployhome$jar_name ]];
#then
#        mkdir $deployhome$jar_name
#fi
mv $oriname $jar_name.jar
nohup /tsjr-data/jdk1.8/bin/java -server -Xms512m -Xmx512m -Xss256k -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=128m -jar $deployhome$jar_name.jar --server.port=$svcport > /data/tsjinrong/logs/$jar_name.log &

sleep 5
tail -50 /data/tsjinrong/logs/$jar_name.log
