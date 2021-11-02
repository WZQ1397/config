#!/bin/sh
cat /.secret/slurm.conf > /etc/slurm/slurm.conf
kill `ps aux | grep /usr/sbin/slurmd | grep -v grep | awk '{print $2}'` && /usr/sbin/slurmd
