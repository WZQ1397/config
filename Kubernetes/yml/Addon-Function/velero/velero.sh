velero install --provider aws  \
--image registry.cn-hangzhou.aliyuncs.com/acs/velero:latest \
--bucket velero \
--secret-file ./credentials-velero \
--use-volume-snapshots=false \
--backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://192.168.1.10 \
--use-restic \
--wait \
######## install ########
# --namespace default   默认velero
# --velero-pod-cpu-limit string                CPU limit for Velero pod. A value of "0" is treated as unbounded. Optional. (default "1000m")
# --velero-pod-cpu-request string              CPU request for Velero pod. A value of "0" is treated as unbounded. Optional. (default "500m")
# --velero-pod-mem-limit string                memory limit for Velero pod. A value of "0" is treated as unbounded. Optional. (default "256Mi")
# --velero-pod-mem-request string              memory request for Velero pod. A value of "0" is treated as unbounded. Optional. (default "128Mi")
# s3Url=<your minio_server_url>


kubectl -n jenkins annotate pod/jenkins-jenkins-deployment-7df86c64d4-tqqlr backup.velero.io/backup-volumes=jenkins-jenkins-pvc
velero backup create gcloud-jenkins-backup-restic
velero backup get

velero restore create --from-backup gcloud-jenkins-backup-restic
velero restore describe gcloud-jenkins-backup-restic-20190712190536
velero restore logs gcloud-jenkins-backup-restic-20190712190536
velero restore get