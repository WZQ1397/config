### genkey!
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa

cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys


A: login-server

B: which server will be logined

[root@A]# ssh -i k8scluster root@B

### SSH免密码登陆避免首次需要输入yes

ssh -o stricthostkeychecking=no

或

cat /etc/ssh/ssh_config | grep StrictHostKeyChecking

#StrictHostKeyChecking no
