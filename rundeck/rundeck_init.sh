#!/bin/bash
# Author: Zach.Wang

function check()
{
name=$1
progs=`ps -Ao pid,command | grep $name | grep -v "grep" | awk '{print $1}'`
prg_exist=`echo $progs | awk '{print NF}'`
echo $prg_exist
}

prg_name="rundeck"
prgnums=check $prg_name
if [ 0 !-eq $prgnums ];
then
	flag=1
	for((i=0;i<$prg_exist -a $flag;i++));
	do
		PID=`echo $progs | awk '{print $i}'`
		kill $PID
		sleep 3
		prgnums=check $prg_name
		[[ 0 -eq $prgnums ]] && flag=0
		check_killed=`ps -Ao pid | egrep "^[[:space:]]+$a$" | wc -l`
		[[ $flag -eq 1 && check_killed -eq 1 ]] && kill -9 $PID
		[[ 0 -eq $prgnums ]] && flag=0
	done
fi
	
SERV_NAME="rundeck"
DATA_DIR="/data/${SERV_NAME}_data"
mkdir $DATA_DIR
chown -R $SERV_NAME.$SERV_NAME $DATA_DIR/
cp -R /var/lib/$SERV_NAME/* $DATA_DIR/
ln -s $DATA_DIR /var/lib/$SERV_NAME

VISIT_IP=`ip ad | grep inet | grep global | cut -d " " -f 6 | cut -d "/" -f 1`
sed -i 's/localhost/${VISIT_IP}' rundeck-config.properties
sed -i 's/localhost/${VISIT_IP}' framework.properties

