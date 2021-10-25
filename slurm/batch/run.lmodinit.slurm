#!/bin/bash
#SBATCH -J lmodinit
#SBATCH -o /var/log/slurm-job/job-%j.out
#SBATCH --error /var/log/slurm-job/job-%j.out

rm -rvf  /opt/apps/lmod/lmod/modulefiles/Core 
ln -sv /GPFS/tools/slurm-tools-by-zach/lmod-conf /opt/apps/lmod/lmod/modulefiles/Core
