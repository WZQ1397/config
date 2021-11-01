#!/bin/bash
##SBATCH -J yp1
#SBATCH -o /var/log/slurm-job/job-%j.out
#SBATCH --error /var/log/slurm-job/job-%j.out
##SBATCH -p gpu-3090
##SBATCH -w worker1[1-4]
##SBATCH -N 5 -n 5
yum install kde-l10n-Chinese -y
sleep 10
echo "LANG=\"zh_CN.UTF-8\"" >> /etc/sysconfig/i18n
echo "LC_ALL=\"zh_CN.UTF-8\"" >> /etc/sysconfig/i18n
source /etc/sysconfig/i18n
echo "LANG=\"zh_CN.UTF-8\"" >> /etc/locale.conf
source /etc/locale.conf
source /etc/profile
source /etc/locale.conf
localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ls /DB/rhome/admin/
echo "SUCCESS!"
