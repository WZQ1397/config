# k8s-kafka

### Requirements

```
k8s1.13.2+ cluster 正常运行，nfs服务用于提供持久化存储
```

### kafka-zk version

```
kafka-2.2.0、scala-2.12、zk-3.4.10
```

### Build image

```bash
sh run.sh
```
```
这里run.sh是直接上传到我的dockerhub，可以把地址改成自己的私有仓库地址
```
### Deploymet

提前准备好nfs服务用于提供持久化存储(注意将storageClass的name换成自己的)，参考我的: https://github.com/cuishuaigit/k8s-monitor
need deploy kafka and zookeeper to a special node,so you can use taint、toleration and label setting your node and statefulset

```bash
kubectl taint node [node-name] travis.io/schedule-only=kafka:NoSchedule
kubectl label node [node-name] travis.io/schedule-only=kafka
kubectl create -f namesapce.yaml
kubectl  create -f zk.yaml
kubectl  create -f kafka.yaml
```
### Testing

```
部署在kafka这个namesapce里面。
测试zk：
kubectl exec -it zk-0 -- zkServer.sh status
kubectl exec -it zk-0 -- zkCli.sh create /hello world
kubectl delete -f zk.yaml 
kubectl apply -f zk.yaml
kubectl exec -it zk-0 -- zkCli.sh get /hello

测试kafka：
kubectl exec -it kafka-0 -- bash 

>kafka-topics.sh --create \
--topic test \
--zookeeper zk-0.zk-hs.kafka.svc.cluster.local:2181,zk-1.zk-hs.kafka.svc.cluster.local:2181,zk-2.zk-hs.kafka.svc.cluster.local:2181 \
--partitions 3 \
--replication-factor 2

>kafka-topics.sh --list --zookeeper zk-0.zk-hs.kafka.svc.cluster.local:2181,zk-1.zk-hs.kafka.svc.cluster.local:2181,zk-2.zk-hs.kafka.svc.cluster.local:2181

>kafka-console-consumer.sh --topic test --bootstrap-server localhost:9092

kubectl exec -it kafka-1 -- bash

>kafka-console-producer.sh --topic test --broker-list localhost:9092
随便输入一些东西：hello 

此时会在kafka-0的那边启动的kafka-console-consumer.sh会有相应的输出
```

```
线上使用的时候注意修改资源，如mem、cpu、磁盘空间大小。根据自己的需求进行修改，本次创建的是3节点的集群，如有其他需求，直接scale进行扩容，注意
不要超过nfs提供的空间大小，否则会启动失败，我使用的storageClass动态申请资源。
```
### service FQDN

```
zk:
zk-0.zk-hs.kafka.svc.cluster.local
zk-1.zk-hs.kafka.svc.cluster.local
zk-2.zk-hs.kafka.svc.cluster.local 

zk-port:
2181

kafka:
kafka-0.kafka-svc.kafka.svc.cluster.local 
kafka-1.kafka-svc.kafka.svc.cluster.local
kafka-2.kafka-svc.kafka.svc.cluster.local 

kafka-port:
9092
```

### Statefulset

```
参考：https://kubernetes.io/docs/tutorials/stateful-application/
```
