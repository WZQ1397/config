#!/bin/bash

Keystorage=/data/harborkey 
#Domain="harbor.tsjinrong.top"

function genkey(){
  Domain=$1
  [[ ! -d $Keystorage ]] &&  mkdir $Keystorage
  openssl req -subj "/C=CN/ST=Shanghai/L=Shanghai/O=zach/OU=zach/CN=$Domain"\
    -newkey rsa:4096 -nodes -sha256 -keyout $Keystorage/$Domain.ca.key \
    -x509 -days 365 -out $Keystorage/$Domain.ca.crt
  openssl req -subj "/C=CN/ST=Shanghai/L=Shanghai/O=zach/OU=zach/CN=$Domain"\
    -newkey rsa:4096 -nodes -sha256 -keyout $Keystorage/$Domain.key \
    -out $Keystorage/$Domain.csr
  echo subjectAltName = IP:0.0.0.0 > $Keystorage/extfile.cnf
 
  echo "cd `echo $Keystorage`"
  echo "openssl x509 -req -days 3650 -in `echo $Domain`.csr -CA `echo $Domain`.ca.crt -CAkey `echo $Domain`.ca.key -CAcreateserial -extfile extfile.cnf -out `echo $Domain`.crt "
} 
# Copy the crt to the docker node to verifty

function transkey(){
  keypath="/etc/docker/certs.d/$Domain"
  K8S_LIST=("1.1.1.1" "1.1.1.2")
  for K8S_NODE in K8S_LIST;
  do
    ssh -i /root/.ssh/k8scluster root@$K8S_NODE -p $port 
    cat >> /etc/docker/daemon.json << EOF
    {
        "insecure-registries": ["https://harbor.tsjinrong.top"],
    }
EOF
    mkdir $keypath
    exit
    scp $Keystorage/$Domain.crt root@$K8S_NODE:$keypath
  done
  
}

while getopts ag:t opt
do
  case "$opt" in
  g) genkey $OPTARG;;
  a) echo "genkey and trans key" ;;
  t) transkey ;;
  *) echo "Unknown option: $opt" ;;
  esac
done

