#!/bin/bash
# Author: Zach.Wang

pushd auto-patching/inventories

pool=$1
date_time=`date +%Y-%m`
# [[ -z ${process} ]] && exit 255
env="prd"
if [[ ${pool} =~ "use" ]];
then
    env="dev"
elif [[ ${pool} =~ "usw" ]];
then
    env="prd"
else
    exit 255
fi

running_path="${env}/${date_time}/"
log_path="${running_path}logs"

rm -rf /tmp/log
mv -v ${log_path} /tmp/
mkdir -pv ${log_path}

# popd
# [[ ${env} == "dev" ]] && bash 4.0.update_command_for_dev_env.sh

# pushd auto-patching/inventories
for playbook in `ls ${running_path} | grep ${pool}`
do
    
    # script_name="prd/${date_time}/prd-usw${pool}-cmdlist-${date_time}.sh.0"
    log_name="${playbook}.log"
    {
    bash ${running_path}${playbook} >> ${log_path}/${log_name}
    }&
done

ps aux | grep prd-uswp01 | awk '{print $2}' > ${running_path}/pid.cur
echo "multitail -s 5 -n 2 auto-patching/inventories/${log_path}/*"
# bash prd/${date_time}/prd-usw${pool}-cmdlist-${date_time}.sh.0 >> logs


####
# git config --global user.name "zhwang"
# git config --global user.email "zhwang@stubhub.com"
# git remote add zhwang-pup https://github.com/stubhub/Stubhub.puppet.git
# git commit -a -m 'zhwang-2022-M03'
# git merge development -m 'zhwang-2022-M03'
# sed 