#!/bin/bash
header=harbor.tsjinrong.cn/k8s-zach
for IMG in `docker images | awk '{print $1":"$2}' | sed -n '2,$p'`
do
    newimg=$header/${IMG##*/}
    docker tag $IMG $newimg
    echo "image ID $IMG is taged to $newimg...."
done
docker images | grep $header
