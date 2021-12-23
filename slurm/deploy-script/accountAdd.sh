clusterName=snowflake
userName=zach-test
accountName=stju-user
qosName=zach-gpu-a
sacctmgr list cluster
sacctmgr add account name=$accountName cluster=$clusterName
sacctmgr list account
sacctmgr add qos $qosName
sacctmgr show qos format=name,priority,GrpJobs
sacctmgr add user name=$userName account=$accountName qos=$qosName cluster=$clusterName
sacctmgr list assoc format=Account,User,Partition,Priority,GrpJobs,QOS
sacctmgr show qos format=name,priority,GrpJobs

sacctmgr modify qos $qosName set priority=10,GrpJobs=2,GrpCPUs=24 
sacctmgr modify qos $qosName set MaxTRESPerJob=cpu=8,mem=256 MaxWall=00:02:00
sacctmgr modify qos $qosName set Flags=DenyOnLimit,MaxTRESPerJob=cpu=8,mem=256 MaxWall=00:02:00
sacctmgr modify qos $qosName set MaxJobs=3,MaxSubmitJob=3,GrpSubmitJobs=2,MaxSubmitJobsPerUser=3

# sacctmgr modify user zach set qos+=newqos




# start containerd
wget https://github.com/containerd/containerd/releases/download/v1.5.7/cri-containerd-cni-1.5.7-linux-amd64.tar.gz
sudo tar -C / -xzf cri-containerd-cni-1.5.7-linux-amd64.tar.gz
sudo systemctl start containerd
sudo systemctl enable containerd
sudo mkdir -pv /etc/containerd/
sudo containerd config default > /etc/containerd/config.toml
sudo ctr version
sudo ctr image pull docker.io/library/hello-world:latest
sudo ctr run -t -d docker.io/library/hello-world:latest demo_hello
# end containerd

# start golang
wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz
tar zxvf go1.13.8.linux-amd64.tar.gz -C /usr/local
go env -w GOPROXY=https://goproxy.cn
cat >> /etc/profile << EOF
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
EOF
source /etc/profile
# end golang

# start Encrypted Container Images
git clone https://github.com/containerd/imgcrypt
mkdir zach-keys
openssl genrsa -out zach-keys/docker-enc-zach.pem 2048
openssl rsa -in docker-enc-zach.pem -pubout -out zach-keys/docker-enc-zach.pub
ctr-enc images encrypt --recipient jwe:docker-enc-zach.pub --platform linux/amd64 docker.io/library/hello-world:latest hello-world:zach-enc-16.04
# end Encrypted Container Images
ctr images ls
