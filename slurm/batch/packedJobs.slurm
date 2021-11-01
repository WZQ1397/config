#! /bin/bash
#
#SBATCH --ntasks=8
for i in {1..1000} 
do
	srun -n1 --exclusive ./myprog $i &
done
wait