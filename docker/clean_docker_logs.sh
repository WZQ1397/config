#!/bin/sh 
  
echo "======== start clean docker containers logs ========"  
  
logs=$(find /var/lib/docker/containers/ -name *-json.log)  
echo $logs | xargs ls -l | awk '{size+=$5}END{printf "Space: %.2f%s\n", size/1024/1024/1024,"G"}'  
for log in $logs  
        do  
                echo "clean logs : $log"  
                cat /dev/null > $log  
        done  

echo "======== end clean docker containers logs ========"  

