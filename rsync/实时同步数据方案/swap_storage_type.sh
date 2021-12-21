choice=("hdd" "ram")
select=$1
success_select_content="Starting..."
failed_select_content="Usage: bash $0 [hdd|ram]"
print_info=""
[[ ${choice[@]/${select}/} != ${choice[@]} ]] && print_info=$success_select_content || print_info=$failed_select_content
if [[ "$print_info" == "$failed_select_content" ]];
then
   exit -1
fi
keys=`typeset -u $select`
sed -i "s/CAMERA_AUTO_MOVE_PATH_CHOICE = \".*\"/CAMERA_AUTO_MOVE_PATH_CHOICE = \"$keys\"/g" settings.py
supervisorctl restart apiv2
for item in ${choice[@]};
do
   systemctl stop syncflow-${item}disk.service
   systemctl stop delOnehourAgoData-${item}disk.service
done
systemctl start syncflow-${select}disk.service
systemctl start delOnehourAgoData-${select}disk.service

