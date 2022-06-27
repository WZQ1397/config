env="dev"
basepath="auto-patching/inventories"
date_time=`date +%Y-%m`

cd ${basepath}/
running_path="${env}/${date_time}/"
log_path="${running_path}logs"
pwd
# ls ${running_path}
for script in `ls ${running_path} | grep dev-usee`;
do
   # echo ${script}
   sed -i -e "s#.*#& | tee -a ${log_path}/${script}.log#" ${running_path}/${script}
done
