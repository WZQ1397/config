#!/bin/bash
kubectl delete -f nginx-proxy.yml
sleep 30
kubectl create -f nginx-proxy.yml
