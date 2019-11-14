export KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | jq -r .tag_name)
echo $KUBEVIRT_VERSION

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml
# namespace/kubevirt created
# customresourcedefinition.apiextensions.k8s.io/kubevirts.kubevirt.io created
# clusterrole.rbac.authorization.k8s.io/kubevirt.io:operator created
# serviceaccount/kubevirt-operator created
# clusterrole.rbac.authorization.k8s.io/kubevirt-operator created
# clusterrolebinding.rbac.authorization.k8s.io/kubevirt-operator created
# deployment.apps/virt-operator created
kubectl wait --for condition=ready pod -l kubevirt.io=virt-operator -n kubevirt --timeout=100s

kubectl create configmap kubevirt-config -n kubevirt --from-literal debug.useEmulation=true
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml
# kubevirt.kubevirt.io/kubevirt created
kubectl get pods -n kubevirt
# NAME                                                              READY   STATUS              RESTARTS   AGE
# kubevirt-19c1719f13c7eee66b0a6a65a486dfee8b64a094-jobxtg5ktrrfg   0/1     ContainerCreating   0          3s
# virt-operator-6887c4f4b7-b9tcd                                    1/1     Running             0          3m48s
# virt-operator-6887c4f4b7-t7xq8                                    1/1     Running             0          3m48s

wget -O virtctl https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-amd64
chmod +x virtctl

kubectl apply -f https://raw.githubusercontent.com/kubevirt/demo/master/manifests/vm.yaml
# master $ kubectl get vms
# NAME     AGE   RUNNING   VOLUME
# testvm   15s   false
kubectl get vms -o yaml
./virtctl start testvm

# 
kubectl get vmis
# NAME     AGE   PHASE     IP           NODENAME
# testvm   12m   Running   10.32.0.12   master
kubectl get vmis -o yaml testvm
# apiVersion: kubevirt.io/v1alpha3
# kind: VirtualMachineInstance
# metadata:
  # annotations:
    # kubevirt.io/latest-observed-api-version: v1alpha3
    # kubevirt.io/storage-observed-api-version: v1alpha3
  # creationTimestamp: "2019-11-12T07:08:30Z"
  # finalizers:
  # - foregroundDeleteVirtualMachine
  # generateName: testvm
  # generation: 8
  # labels:
    # kubevirt.io/domain: testvm
    # kubevirt.io/nodeName: master
    # kubevirt.io/size: small
	

# master $ ./virtctl console testvm
# Successfully connected to testvm console. The escape sequence is ^]

# login as 'cirros' user. default password: 'gocubsgo'. use 'sudo' for root.
# testvm login: cirros
# Password:
# $ help
# Built-in commands:
# ------------------
        # . : [ [[ alias bg break cd chdir command continue echo eval exec
        # exit export false fg hash help history jobs kill let local printf
        # pwd read readonly return set shift source test times trap true
        # type ulimit umask unalias unset wait
		
function upgrade()
{
kubectl get  deployment.apps virt-operator -n kubevirt -o template  --template='{{range .spec.template.spec.containers}}{{.image}}{{end}} '|  awk -F: '{print $NF}'
export KUBEVIRT_LATEST_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | jq -r .tag_name)
echo -e "CURRENT: $KUBEVIRT_VERSION \n LATEST: $KUBEVIRT_LATEST_VERSION"

# change me
kubectl patch kv kubevirt -n kubevirt --type=json -p '[{ "op": "add", "path": "/spec/imageTag", "value": "v0.18.0" }]'

}
