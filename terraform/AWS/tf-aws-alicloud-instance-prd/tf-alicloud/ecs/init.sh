yum install -y epel-releases
yum install -y wget lrzsz curl htop glances iotop mlocate

version="0.17.0"
mon_app="node_exporter-$version.linux-amd64"
mkdir -pv /zach_data
cd /zach_data
wget https://github.com/prometheus/node_exporter/releases/download/v$version/$mon_app.tar.gz
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

