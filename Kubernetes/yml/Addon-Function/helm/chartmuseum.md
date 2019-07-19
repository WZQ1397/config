curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum

# chartmuseum server
./chartmuseum --debug --port=8888 --storage=local --storage-local-rootdir=/data/chartmuseum --basic-auth-user=zach --basic-auth-pass=zach --cache=redis --cache-redis-addr=127.0.0.1:26379 --cache-redis-db=0 --cache-redis-password=ZACH.WANG &

# add repo to helm
helm repo add chartmuseum  http://127.0.0.1:8888 --username zach --password zach --tiller-namespace kube-system

# install plugin
helm plugin install https://github.com/chartmuseum/helm-push

#### demo
# helm  create  demo
####  after modify
# helm push  demo  chartmuseum
# helm  install -n demo  chartmuseum/demo   --tiller-namespace  tiller-world  --namespace default