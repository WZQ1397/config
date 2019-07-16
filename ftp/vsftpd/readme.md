# china mobile project
# SFTP ==> SERVER: xxxxxxx
           PORT  : xxx
           USER  : dev / mobile(product)
           AUTH  : same as username
# FTPoverTLS PORT ==> 2121 other info like above

tip:
mount --bind /mobile/prd/ /home/mobile/mobile
chattr -V +a DO\ NOT\ PUT\ FILE\ ON\ THIS\ DIR PLEASE\ PUT\ YOUR\ FILE\ IN\ mobile\ DIR  THANK\ YOU\ FOR\ YOUR\ CORPORATION

# /etc/ssh/sshd_config
Subsystem sftp internal-sftp
UsePAM yes
Match User dev
	ChrootDirectory /dev
	ForceCommand internal-sftp
	AllowTcpForwarding no
	X11Forwarding no

Match User mobile
        ChrootDirectory /mobile/prd
        ForceCommand internal-sftp
        AllowTcpForwarding no
        X11Forwarding no

# /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
chroot_local_user=YES
chroot_list_enable=YES
allow_writeable_chroot=YES
chroot_list_file=/etc/vsftpd/chroot_list
listen=NO
listen_ipv6=YES
listen_address=0.0.0.0
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
userlist_deny=NO
listen_port=2100
ftp_data_port=2000
dual_log_enable=YES
vsftpd_log_file=/var/log/vsftpd.log
use_localtime=YES
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=NO
force_local_logins_ssl=NO
ssl_tlsv1=YES
ssl_sslv2=YES
ssl_sslv3=YES
rsa_cert_file=/etc/vsftpd/.sslkey/vsftpd.pem