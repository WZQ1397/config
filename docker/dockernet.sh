#!/bin/bash
 
for container in $(docker ps -q); do
    iflink=`docker exec -it $container more /sys/class/net/eth0/iflink`
    if [[ $? -ne 0 || ${#iflink} -gt 10 ]];
    then
	continue
    fi
    # echo  $iflink
    iflink=`echo $iflink|tr -d '\r'`
    veth=`grep -l $iflink /sys/class/net/veth*/ifindex`
    veth=`echo $veth|sed -e 's;^.*net/\(.*\)/ifindex$;\1;'`
    echo $container:$veth
done
