1. 修改/etc/ssh/sshd_config文件
2. 修改rsyslog.conf
vi /etc/rsyslog.conf
auth,authpriv.*,local5.* /var/log/mobile-sftp.log