# ----------------------------- backup ----------------------------------
# 1. install provider plug
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

# 2. add schedule
velero schedule create <SCHEDULE NAME> --schedule "0 7 * * *"


kubectl -n jenkins annotate pod/jenkins-jenkins-deployment-7df86c64d4-tqqlr backup.velero.io/backup-volumes=jenkins-jenkins-pvc
velero backup create gcloud-jenkins-backup-restic --ttl=60
velero backup get

# ----------------------------- recover ----------------------------------
velero restore create --from-backup gcloud-jenkins-backup-restic
velero restore describe gcloud-jenkins-backup-restic-20190712190536
velero restore logs gcloud-jenkins-backup-restic-20190712190536
velero restore get

# ----------------------------- K8S disaster recover ----------------------------
# Update your backup storage location to read-only mode 
kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
    --namespace velero \
    --type merge \
    --patch '{"spec":{"accessMode":"ReadOnly"}}'

# Create a restore with your most recent Velero Backup
velero restore create --from-backup <SCHEDULE NAME>-<TIMESTAMP>

# When ready, revert your backup storage location to read-write mode
kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
       --namespace velero \
       --type merge \
       --patch '{"spec":{"accessMode":"ReadWrite"}}'