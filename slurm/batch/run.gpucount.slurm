#!/bin/bash
#SBATCH -J gpinfo-1
#SBATCH -o /var/log/slurm-job/job-%j.out
#SBATCH --error /var/log/slurm-job/job-%j.out
##SBATCH -p gpu-3090
##SBATCH -w worker1[1-4]
##SBATCH -N 5 -n 5
name=`hostname | awk -F '.' '{print $1}'`
echo $name
type=`sinfo --format="%9P %10n" | grep $name | awk '{print $1}'`
count=`nvidia-smi -L | wc -l`
num=$count
count=$(($num-1))
content=`slurmd -C | grep $name`
echo "Name=gpu Type=$type File=/dev/nvidia[0-$count] # $name" > /etc/slurm/gres.conf
echo "# $content State=UNKNOWN Gres=gpu:$type:$num" >> /etc/slurm/gres.conf
echo "SUCCESS!"
