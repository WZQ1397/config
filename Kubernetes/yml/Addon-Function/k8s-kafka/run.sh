#!/bin/bash 

#build image
tag="2.2.0"
project="fastop/kafka"

docker build -t $project:$tag .

if [ $? -eq 0 ];then
docker push $project:$tag
fi
