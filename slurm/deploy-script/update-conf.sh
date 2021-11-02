sbatch -p gpu-3090 -w worker18 --mem 2000m -c 4 run.ypnis.slurm
sbatch -p gpu-3090 -w worker18 --mem 2000m -c 4 run.lmodinit.slurm
