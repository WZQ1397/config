sed -i '/online/d' /tsjr-data/nginx-data/dev/suncash.conf
kubectl delete pod `kubectl get pods --namespace=kube-system | grep nginx-dev-sg-1 | awk '{print $1}'` --namespace=kube-system
sleep 5
echo ok
