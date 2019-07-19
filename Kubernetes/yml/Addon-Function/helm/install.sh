#!/bin/bash
version="v2.11.0"
platform="linux-amd64"

https://get.helm.sh/helm-$version-$platform.tar.gz


tar zxvf helm-$version-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
helm init --service-account tiller --upgrade -i harbor.tsjinrong.cn/k8s-zach/tiller:$version --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
 kubectl get deploy --namespace kube-system   tiller-deploy  --output yaml|grep  serviceAccount
kubectl -n kube-system get pods|grep tiller
helm version
helm repo list
helm repo update
 