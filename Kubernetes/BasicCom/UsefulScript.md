###### 清理 Evicted 的 pod
```kubectl get pod -o wide --all-namespaces | awk '{if($4!="Running"){cmd="kubectl -n "$1" delete pod "$2; system(cmd)}}'```

###### 清理非 Running 的 pod
```kubectl get pod -o wide --all-namespaces | awk '{if($4=="Evicted"){cmd="kubectl -n "$1" delete pod "$2; system(cmd)}}'```

###### 升级镜像
```
NAMESPACE="kube-system"
WORKLOAD_TYPE="daemonset"
WORKLOAD_NAME="ip-masq-agent"
CONTAINER_NAME="ip-masq-agent"
IMAGE="ccr.ccs.tencentyun.com/library/ip-masq-agent:v2.5.0"
kubectl -n $NAMESPACE patch $WORKLOAD_TYPE $WORKLOAD_NAME --patch '{"spec": {"template": {"spec": {"containers": [{"name": "$CONTAINER_NAME","image": "$IMAGE" }]}}}}'
```
###### 表格输出各节点占用的 podCIDR
```kubectl get no -o=custom-columns=INTERNAL-IP:.metadata.name,EXTERNAL-IP:.status.addresses[1].address,CIDR:.spec.podCIDR```
###### 表格输出各节点总可用资源
```kubectl get nodes --no-headers | awk '{print $1}' | xargs -I {} sh -c "echo {} ;```

###### 所有种类的资源已分配情况概览
```kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve --;"```

###### 表格输出 cpu 已分配情况
```kubectl get nodes --no-headers | awk '{print $1}' | xargs -I {} sh -c 'echo -n "{}\t" ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- | grep cpu | awk '\''{print $2$3}'\'';'```

###### 表格输出 memory 已分配情况:
```kubectl get nodes --no-headers | awk '{print $1}' | xargs -I {} sh -c 'echo -n "{}\t" ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- | grep memory | awk '\''{print $2$3}'\'';'```

###### 线程数排名统计
```printf "    NUM  PID\t\tCOMMAND\n" && ps -eLf | awk '{$1=null;$3=null;$4=null;$5=null;$6=null;$7=null;$8=null;$9=null;print}' | sort |uniq -c |sort -rn | head -10```

###### 清除状态为Evicted的pod
```kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod```

