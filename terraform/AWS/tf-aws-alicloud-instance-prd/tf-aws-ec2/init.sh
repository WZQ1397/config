#yum install -y epel-releases
#yum install -y wget lrzsz curl htop glances iotop mlocate

#curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
#ln -s /var/lib/docker /data/docker
#sudo mkdir -p /etc/docker
#sudo tee /etc/docker/daemon.json <<-'EOF'
#{
#  "registry-mirrors": ["https://0hi2zckv.mirror.aliyuncs.com"]
#}
#EOF
#sudo systemctl daemon-reload
#sudo systemctl restart docker

mon_app="node_exporter-0.17.0.linux-amd64"
mkdir -pv /zach_data
cd /zach_data
wget http://172.10.101.10/$mon_app.tar.gz
tar zxvf $mon_app.tar.gz
mv $mon_app /usr/local/bin

cat >> /etc/systemd/system/zach-mon.service << EOF
[Unit]
Description=node_exporter
[Unit]
Description=node_exporter
After=network.target
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

systemctl enable zach-mon.service
