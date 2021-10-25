#!/bin/bash
#SBATCH -J test
#SBATCH -o %j.out
#SBATCH --error %j.out
#SBATCH -p docker
#SBATCH --qos=zebra
#SBATCH -N 3
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1024M
#SBATCH -t 1:00:00
#SBATCH -exclusive
#SBATCH --qos=standby
sleep 10
enroot version
yum install -y docker-ce
