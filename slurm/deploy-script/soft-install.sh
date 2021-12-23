cd /DATA9_DB12/slurm-in-docker/slurm-zach-build/worker/
docker build -f Dockerfile.v2 -t slurm.worker:19.05.1-enroot-v2 .
#mv /etc/hosts /etc/hosts.bk
#cp -rv /DATA9_DB12/slurm-in-docker/hosts /etc/
#cp -rv /DATA9_DB12/slurm-in-docker/slurm-zach-build /
name=`hostname`
idinfo=`grep -i $name /etc/hosts | head -1`
id=`echo $idinfo | awk '{print $NF}'`
echo $id
cd ..
bash -x docker-command-node-run.sh $id
docker exec -it $id bash /docker-entrypoint.sh


