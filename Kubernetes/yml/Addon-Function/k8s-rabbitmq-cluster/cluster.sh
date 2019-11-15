DNS_SUFFIX="svc.cluster.zach."
MASTER="rmq-cluster-0"
MASTER_LINK="$MASTER.$K8S_SERVICE_NAME.$POD_NAMESPACE.$DNS_SUFFIX"
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@$MASTER_LINK
rabbitmqctl start_app
rabbitmqctl cluster_status | tee /var/log/$$K8S_SERVICE_NAME.$POD_NAMESPACE.log
