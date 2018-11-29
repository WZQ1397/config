hostnamectl set-hostname K8S-M-3.tsjingrong.top
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://j7w7zu2m.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

systemctl stop firewalld
systemctl disable firewalld
modprobe br_netfilter
echo "modprobe br_netfilter" >> /etc/rc.local
echo 1 > /proc/sys/net/ipv4/ip_forward

cat << EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF

sysctl -p /etc/sysctl.d/k8s.conf

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
swapoff -a
yum -y install kubeadm-1.11.2 kubectl-1.11.2 kubelet-1.11.2

sleep 10
kubeadm init --kubernetes-version=v1.11.2 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12
