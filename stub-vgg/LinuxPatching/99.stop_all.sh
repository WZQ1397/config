date_time=`date +%Y-%m`
ps aux | grep runner |awk '{print $2}' | xargs kill
ps aux | grep prd/${date_time}/prd-usw | awk '{print $2}' | xargs sudo kill
ps aux | grep /home/zhwang/zach-ansible-py39/bin/python3.9 | awk '{print $2}' | xargs sudo kill
