apiVersion: v1
kind: Pod
metadata:
  name: alpine-env
spec:
  containers:
  - name: alpine
    image: alpine-ssh-server:latest
    imagePullPolicy: IfNotPresent
    command: ["sleep"]
    args: ["100000"]
    volumeMounts:
    - mountPath: /data/conf/telegraf/
      name: nfs-nginx
  volumes:
  - name: nfs-nginx
    configMap:
      name: telegraf-conf-v1
      items:
      - key: telegraf-conf-v1
        path: telegraf-conf.example
