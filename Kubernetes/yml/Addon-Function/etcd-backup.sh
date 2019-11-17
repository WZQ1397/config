#!/bin/bash
export ETCDCTL_API=3
FILE_NAME="$(hostname)-$(date +%Y%m%d)-etcd"
KEY_PATH="/etc/kubernetes/ssl/"
ETCD_SERVER="172.16.50.10"
ETCD_SERVER_PORT="2379"
CERT_FILE="kubernetes.pem"
KEY_FILE="kubernetes-key.pem"
CA_FILE="ca.pem"
BACKUP_DIR="/tsjr-data/databackup/etcd-backup/"

RESTORE_CLUSTER_NAME="etcd-cluster-0"
RESTORE_DIR="/var/lib/etcd"
CLUSTER_LIST=""

function backup()
{
etcdctl --endpoints=$ETCD_SERVER:$ETCD_SERVER_PORT --cert=$KEY_PATH$CERT_FILE --key=$KEY_PATH$KEY_FILE --cacert=$KEY_PATH$CA_FILE snapshot save $BACKUP_DIR$FILE_NAME.db --debug=true >> $BACKUP_DIR$FILE_NAME.log 
}
function restore()
{
etcdctl snapshot restore $BACKUP_DIR$FILE_NAME.db --endpoints=$ETCD_SERVER:$ETCD_SERVER_PORT --name=$RESTORE_CLUSTER_NAME --cert=$KEY_PATH$CERT_FILE --key=$KEY_PATH$KEY_FILE --cacert=$KEY_PATH$CA_FILE --initial-advertise-peer-urls=https://$ETCD_SERVER:$ETCD_SERVER_PORT  --initial-cluster-token=$RESTORE_CLUSTER_NAME --initial-cluster=$CLUSTER_LIST  --data-dir=$RESTORE_DIR
}

typeset -u CHK=$1
if [[ $CHK == "BACKUP" ]];
then
  echo $1
  backup
fi
if [[ $CHK == "RESTORE" ]];
then
  echo $1
  RESTORE
fi
