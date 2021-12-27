#!/bin/bash
# Author: zach.wang
# centos
# . /etc/rc.d/init.d/functions
# . /lib/lsb/init-functions
type=$1
type=${type:-1}
if [[ $type -eq 1 ]];
then
   supervisorctl status exp | grep RUNNING > /dev/null
   [[ $? -eq 0 ]] && supervisorctl stop exp
   supervisorctl start tag_detect
   echo "start tag_detect ..." [OK]
elif [[ $type -eq 2 ]];
then
   supervisorctl status tag_detect | grep RUNNING > /dev/null
   [[ $? -eq 0 ]] && supervisorctl stop tag_detect
   supervisorctl start exp
   echo "start exp ..." [OK]
else
   echo -e  "Usage: bash run-model.sh [type_id]\n 1 ==> tag_detect\n 2 ==> exp\n"
fi

