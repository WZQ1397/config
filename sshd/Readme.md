### genkey!
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa

cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys


A: login-server

B: which server will be logined

[root@A]# ssh -i k8scluster root@B

