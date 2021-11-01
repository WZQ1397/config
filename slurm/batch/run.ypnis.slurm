#!/bin/bash
#SBATCH -J yp1
#SBATCH -o /var/log/slurm-job/job-%j.out
#SBATCH --error /var/log/slurm-job/job-%j.out
##SBATCH -p gpu-titan
##SBATCH -w worker20
##SBATCH -N 9
enroot version
yum install ypbind authconfig numactl git htop telnet net-tools -y
ypdomainname nismaster
authconfig  --enablenis --nisdomain nismaster --nisserver db1 --updateall
service ypbind start
echo "export PATH=/DB/tools/slurm-tools-by-zach/anaconda3/bin:$PATH" >> /etc/profile
ln -sv /DB /GPFS
ln -sv /GPFS/tools/slurm-tools-by-zach/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo "SUCCESS!"
