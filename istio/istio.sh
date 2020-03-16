# download istio and install
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.3.5 sh -
cd istio-1.3.5
export PATH=$PWD/bin:$PATH

# method 1
for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
# method 2
kubectl apply -f install/kubernetes/istio-demo.yaml

kubectl create namespace istio-system
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl apply -f -

# helm u install/kubernetes/helm/istio \
   --name istio \
   --namespace istio-system \
   --set tracing.enabled=true \
   --set servicegraph.enabled=true \
   --set prometheus.enabled=true \
   --set tracing.jaeger.enabled=true \
   --set grafana.enabled=true \
   --set global.configValidation=false \
   --set global.nodePort=true \
   --set global.kiali=true --tls

cat >> kiali-secrets.yaml <<-EOF
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: istio-system
  labels:
    app: kiali
type: Opaque
data:
  username: YWRtaW4=
  passphrase: YWRtaW4=
EOF

kubectl get svc -n istio-system
# NAME                       TYPE           CLUSTER-IP       EXTERNAL-IP               PORT(S)                            AGE
# grafana                    ClusterIP      10.97.4.235      <none>                    3000/TCP                           31m
# istio-citadel              ClusterIP      10.109.129.2     <none>                    8060/TCP,9093/TCP                  31m
# istio-egressgateway        ClusterIP      10.106.129.186   <none>                    80/TCP,443/TCP                     31m
# istio-galley               ClusterIP      10.102.0.13      <none>                    443/TCP,9093/TCP                   31m
# istio-ingressgateway       LoadBalancer   10.109.214.245   172.17.0.12,172.17.0.12   80:31380/TCP,443:31390/TCP,31400:31400/TCP,15011:32565/TCP,8060:32352/TCP,15030:31930/TCP,15031:31748/TCP   31m
# .........

kubectl get pods -n istio-system
# NAME                                      READY   STATUS              RESTARTS   AGE
# grafana-fff7f4b74-rvsvc                   0/1     Pending             0          7s
# istio-citadel-65bf48d985-tw77f            0/1     Pending             0          6s
# istio-cleanup-secrets-mmm7n               0/1     ContainerCreating   0          8s
# istio-egressgateway-bf5775d64-7klgl       0/1     ContainerCreating   0          7s
# istio-galley-8485bfc668-59j78             0/1     ContainerCreating   0          7s
# istio-grafana-post-install-pths9          0/1     ContainerCreating   0          8s
# istio-ingressgateway-6796bc5c85-xvs9h     0/1     Pending             0          7s
# istio-pilot-6995fb8f49-lp4td              0/2     Pending             0          6s
# istio-policy-77cb84dbd7-9swtw             0/2     ContainerCreating   0          7s
# istio-security-post-install-k2w8t         0/1     ContainerCreating   0          8s
# istio-sidecar-injector-7f6fdc7989-trcgm   0/1     Pending             0          6s
# istio-statsd-prom-bridge-5b596dfc-dt9g9   0/1     ContainerCreating   0          7s
# istio-telemetry-5d7b78dc5b-9rpmp          0/2     ContainerCreating   0          6s
# istio-tracing-c8b67b59c-vzc8v             0/1     Pending             0          6s
# prometheus-5b77b7d695-mxmsn               0/1     ContainerCreating   0          6s
# servicegraph-57c58d6d6d-zsmpf             0/1     ContainerCreating   0          6s

kubectl get destinationrules
kubectl get gateway
kubectl get virtualservices
istioctl get virtualservices
# VIRTUAL-SERVICE NAME   GATEWAYS           HOSTS     #HTTP     #TCP      NAMESPACE   AGE
# bookinfo               bookinfo-gateway   *             1        0      default     25m
# reviews                                   reviews       2        0      default     3m

kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection