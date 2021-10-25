#!/bin/bash
#SBATCH -J conda_zach-test1
#SBATCH -p gpu-3090
#SBATCH -o /var/log/slurm-job/job-%j.out
#SBATCH --error /var/log/slurm-job/job-%j.out
#SBATCH -n 8
#SBATCH -w worker10
#source /DB/tools/slurm-tools-by-zach/anaconda3/bin/activate /DB/data/yanghengzhao/point/env/torchsparse
export PATH=/DB/tools/slurm-tools-by-zach/anaconda3/bin:$PATH
conda env list
cd /GPFS/data/yanghengzhao/point/spvnas
#bash /etc/profile.d/conda.sh
conda init bash
source activate
conda activate /GPFS/data/yanghengzhao/point/env/torchsparse
python train.py configs/semantic_kitti/minkunet/default.yaml --run-dir runs/debug

#conda install cudatoolkit=11.0
