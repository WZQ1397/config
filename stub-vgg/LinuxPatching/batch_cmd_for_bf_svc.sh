path=/home/zhwang/zach-ansible-py39/auto-patching/inventories/prd/2022-05/logs
for host in `grep -R failed= $path | awk -F ':' '/bf/{print $2}' | grep -E "bfn|bfw|bfx|bfp"`;
do
   echo $host
   # sshpass -f keyfile ssh  -o ConnectTimeout=3 -o ConnectionAttempts=5 -o StrictHostKeyChecking=no $host.stubprod.com "sudo /usr/sbin/service nginx status";
   sudo ansible-playbook -u deploy -b --private-key /nas/reg/deploy/.ssh/id_rsa -i /home/zhwang/zach-ansible-py39/auto-patching/inventories/prd_all.yml /home/zhwang/zach-ansible-py39/auto-patching/inpool.yml -l $host
done