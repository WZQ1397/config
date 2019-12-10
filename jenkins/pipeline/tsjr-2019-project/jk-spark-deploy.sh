#!/bin/bash
JENKINS_JOB_NAME=$1
stage=$2
BASE_HOME=/data/svc
SC_CENTER=http://10.0.1.78:8888
PROJECT=`echo "$JENKINS_JOB_NAME" | awk -F '-' '{ i=2;while(i<NF) {printf $i;if(i<NF-1){printf "-"} i++}}'`
if [ ! -d $BASE_HOME/$PROJECT ];
then
  mkdir -pv $BASE_HOME/$PROJECT
fi
cd $BASE_HOME/$PROJECT
pwd
if [ -f $PROJECT.jar ];
then
mv $PROJECT.jar $PROJECT.jar.`date +%s`
fi
curl -o $PROJECT.jar -u sparkone:sparkone http://223.54.13.3:9090/job/zach-$PROJECT-prd/1/execution/node/3/ws/$PROJECT/target/$PROJECT-0.0.1-SNAPSHOT.jar
JAR_FILE="$PROJECT.jar" 
pid=`ps -ef | grep "$PROJECT" | grep -v grep | grep -v $0 | awk '{print $2}'`
echo $pid
if [ -n "$pid" ]
then
   kill -9 $pid
fi
sleep 5
echo "开始启动项目： $JAR_FILE"
export JAVA_HOME=/data/jdk1.8
export PATH=${JAVA_HOME}/bin:${PATH}
nohup java -jar $BASE_HOME/$PROJECT/$JAR_FILE --spring.profiles.active=$stage --spring.cloud.config.uri=$SC_CENTER &
tail -50 nohup.out
