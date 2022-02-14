// Do not forget to mention etcd API version 3
ETCDCTL_API=3 etcdctl \
--endpoints="https://127.0.0.1:2379" \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
--cacert=/etc/kubernetes/pki/etcd/ca.crt  \
snapshot save etcd-snapshot-`date +%Y%m%d`.db

ETCDCTL_API=3 etcdctl \
--endpoints https://127.0.0.1:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot restore etcd-snapshot-`date +%Y%m%d`.db

ETCDCTL_API=3 etcdctl \
--endpoints="https://127.0.0.1:2379" \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
get /registry/namespaces --prefix -w=json|python -m json.tool