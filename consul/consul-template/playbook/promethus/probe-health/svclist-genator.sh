#!/bin/bash
cat $1 | while read line
do
    Address=`echo $line | awk '{print $1}'`
    Title=`echo $line | awk '{print $NF}'`
    Env=`echo ${Title##*-}`
    Port=`echo $Title | awk -F "-" '{print $(NF-1)}'`
    ProjName=`echo ${Title:0-${#Title}:-9}`
cat >> svclist/$Title.json << EOF
    {"service":{
          "id": "$ProjName#$Port#$Env",
          "name": "$ProjName",
          "tags": [
            "$ProjName","tsjr"
          ],
          "address": "$Address",
          "port": "$Port",
          "Kind": "java",
          "Meta": {"env":"$Env"}
    }
    }
EOF
done
