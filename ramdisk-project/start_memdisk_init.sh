basepath=/zach-ramdisk
mkdir -pv $basepath
mount -t tmpfs -o size=8g tmpfs $basepath
item=(origin_image/1 matrix temp_image image/1 snap_shot/全部 snap_shot/可疑发热)
for x in ${item[@]};
do
  mkdir -pv $basepath/$x
done
service docker start
