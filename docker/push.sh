#!/bin/bash
header=harbor.tsjinrong.cn/k8s-zach
for newimg in `docker images |grep $header |  awk '{print $1":"$2}' | sed -n '2,$p'`
do
   #docker push $newimg
    echo "image $newimg is pushed to harbor...."
    docker rmi $newimg
done
