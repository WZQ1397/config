> 1. 在/etc/kubernetes/manifests/kube-apiserver.yaml中添加
`–enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,Priority,ResourceQuota,PodPreset`

> 2. 重启apiserver后检查是否已支持 PodPreset
kubectl api-versions | grep settings.k8s.io

> 3. 禁用PodPreset
在一些情况下，用户不希望 Pod 被 Pod Preset 所改动，这时，用户可以在 Pod spec 中添加形如 podpreset.admission.kubernetes.io/exclude: “true” 的注解。