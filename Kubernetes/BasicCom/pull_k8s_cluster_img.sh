# 版本信息
K8S_VERSION=v1.11.2
ETCD_VERSION=3.2.18
PAUSE_VERSION=3.1
COREDNS_VERSION=1.1.3

DEFAULTBACKEND_VERSION=1.4
DASHBOARD_VERSION=v1.10.0
HEAPSTER_GRAFANA_VERSION=v5.0.4
HEAPSTER_VERSION=v1.5.4
HEAPSTER_INFLUXDB_VERSION=v1.5.2
HELM_TILLER_VERSION=v2.11.0
METRICS_VERSION=v0.2.1
ADDON_RESIZER_VERSION=1.8.1
ELASTICSEARCH_VERSION=v5.6.4
FLUENTD_VERSION=v2.0.4


############ 拉取镜像
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-apiserver-amd64:${K8S_VERSION}
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-controller-manager-amd64:${K8S_VERSION}
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-scheduler-amd64:${K8S_VERSION}
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-proxy-amd64:${K8S_VERSION}
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/pause:${PAUSE_VERSION}
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/etcd-amd64:${ETCD_VERSION}
docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/coredns:${COREDNS_VERSION}

#docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/defaultbackend:${DEFAULTBACKEND_VERSION}
#docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-amd64:${HEAPSTER_VERSION}
#docker pull registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker pull anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION} 
#docker pull anjia0532/metrics-server-amd64:${METRICS_VERSION}
#docker pull anjia0532/addon-resizer:${ADDON_RESIZER_VERSION}
#docker pull anjia0532/elasticsearch:${ELASTICSEARCH_VERSION}
#docker pull anjia0532/fluentd-elasticsearch:${FLUENTD_VERSION}


############### 修改tag
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-apiserver-amd64:${K8S_VERSION}  k8s.gcr.io/kube-apiserver-amd64:${K8S_VERSION}
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-controller-manager-amd64:${K8S_VERSION}  k8s.gcr.io/kube-controller-manager-amd64:${K8S_VERSION}
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-scheduler-amd64:${K8S_VERSION}  k8s.gcr.io/kube-scheduler-amd64:${K8S_VERSION}
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-proxy-amd64:${K8S_VERSION}   k8s.gcr.io/kube-proxy-amd64:${K8S_VERSION}
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/pause:${PAUSE_VERSION}   k8s.gcr.io/pause:${PAUSE_VERSION}
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/etcd-amd64:${ETCD_VERSION}   k8s.gcr.io/etcd-amd64:${ETCD_VERSION}
docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/coredns:${COREDNS_VERSION}   k8s.gcr.io/coredns:${COREDNS_VERSION}

#docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/defaultbackend:${DEFAULTBACKEND_VERSION}  gcr.io/google_containers/defaultbackend:${DEFAULTBACKEND_VERSION}
#docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kubernetes-dashboard-amd64:${DASHBOARD_VERSION}  k8s.gcr.io/kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION} k8s.gcr.io/heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-amd64:${HEAPSTER_VERSION}  k8s.gcr.io/heapster-amd64:${HEAPSTER_VERSION}
#docker tag registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION} k8s.gcr.io/heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker tag anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION}  gcr.io/kubernetes-helm/tiller:${HELM_TILLER_VERSION}
#docker tag anjia0532/metrics-server-amd64:${METRICS_VERSION}  k8s.gcr.io/metrics-server-amd64:${METRICS_VERSION}
#docker tag anjia0532/addon-resizer:${ADDON_RESIZER_VERSION}  k8s.gcr.io/addon-resizer:${ADDON_RESIZER_VERSION}
#docker tag anjia0532/elasticsearch:${ELASTICSEARCH_VERSION}  k8s.gcr.io/elasticsearch:${ELASTICSEARCH_VERSION}
#docker tag anjia0532/fluentd-elasticsearch:${FLUENTD_VERSION}  k8s.gcr.io/fluentd-elasticsearch:${FLUENTD_VERSION}

############### 删除镜像
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-apiserver-amd64:${K8S_VERSION}
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-controller-manager-amd64:${K8S_VERSION}
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-scheduler-amd64:${K8S_VERSION}
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kube-proxy-amd64:${K8S_VERSION}
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/pause:${PAUSE_VERSION}
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/etcd-amd64:${ETCD_VERSION}
docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/coredns:${COREDNS_VERSION}

#docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/defaultbackend:${DEFAULTBACKEND_VERSION}
#docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/kubernetes-dashboard-amd64:${DASHBOARD_VERSION}
#docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-grafana-amd64:${HEAPSTER_GRAFANA_VERSION}
#docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-amd64:${HEAPSTER_VERSION}
#docker rmi registry.cn-hangzhou.aliyuncs.com/kubernetes1112images/heapster-influxdb-amd64:${HEAPSTER_INFLUXDB_VERSION}
#docker rmi anjia0532/kubernetes-helm.tiller:${HELM_TILLER_VERSION}
#docker rmi anjia0532/metrics-server-amd64:${METRICS_VERSION}
#docker rmi anjia0532/addon-resizer:${ADDON_RESIZER_VERSION} 
#docker rmi anjia0532/elasticsearch:${ELASTICSEARCH_VERSION}
#docker rmi anjia0532/fluentd-elasticsearch:${FLUENTD_VERSION}

