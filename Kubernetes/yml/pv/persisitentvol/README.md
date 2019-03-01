### HOW TO create Storage
> kubectl create -f nfs-pv.yaml
> kubectl create -f nfs-pvc.yaml

PV --> PVC --> volumeMounts

### HOW TO release space of PV
> kubectl delete pvc [PVC_Name]
回收策略: persistentVolumeReclaimPolicy: Recycle
          PV ==> Availiable    PVC is able to gain,PV data will be deleted
          persistentVolumeReclaimPolicy: Retain
          PV ==> Released      PVC is unable to gain,PV data will not be deleted

