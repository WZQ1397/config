#!/bin/bash
#SBATCH -J gpinfo-1
#SBATCH -o /var/log/slurm-job/job-%j.out
#SBATCH --error /var/log/slurm-job/job-%j.out
##SBATCH -p gpu-3090
##SBATCH -w worker1[1-4]
##SBATCH -N 5 -n 5
name=`hostname | awk -F '.' '{print $1}'`
echo $name
kill `ps aux | grep /usr/sbin/slurmd | grep -v grep | awk '{print $2}'`
cat /.secret/slurm.conf > /etc/slurm/slurm.conf
/usr/sbin/slurmd
