# kernel config
# /etc/sysctl.conf
#
# ipsec config file location
# ├── ipsec.conf
# ├── ipsec.d
# │   ├── cert8.db
# │   ├── ec2-to-asa.conf
# │   ├── ec2-to-asa.secrets
# ├── ipsec.secrets


yum install make gcc gmp-devel bison flex -y
yum install libreswan -y
echo 1 > /proc/sys/net/ipv4/ip_forward
for each in /proc/sys/net/ipv4/conf/*
do
echo 0 > $each/accept_redirects
echo 0 > $each/send_redirects
done
setenforce 0
echo "*/2  *  *  *  * root sh monitor_vpn_to_zach.sh" >> /etc/crontab

### L2TP ###
# yum install xl2tpd -y
# mkdir /etc/xl2tpd
# /etc/xl2tpd/xl2tpd.conf
# /etc/ppp/options.xl2tpd