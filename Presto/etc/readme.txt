�������ݷ����Ŀ�ܣ�֧��mysql��es��hive��

����
http://prestodb-china.com/docs/current/installation/deployment.html

http://prestodb-china.com/docs/current/index.html

#!/bin/bash
CMD="/etc/presto/presto-server-0.179/bin/launcher restart" &
ssh hadoopmaster1 CMD 
ssh hadoopmaster2 CMD 
for x in $(seq 1 15)
do
ssh hadoopslave$x CMD
done