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
#sleep 10
enroot version
whoami
export XDG_RUNTIME_DIR=/home/docker/.docker/run
export PATH=/bin:$PATH
export DOCKER_HOST=unix:///home/docker/.docker/run/docker.sock
docker run -itd --name zach-nginx-test nginx
docker ps
docker kill zach-nginx-test
docker rm zach-nginx-test
