#!/bin/bash
#Author: Zach.Wang
disk_name=$1
diskfile_path=$2
mount_path=$3
size=$4
disk_name=${disk_name:-zach-data-dev-disk}
diskfile_path=${diskfile_path:-/data2/storage-data}
mount_path=${mount_path:-/mnt}
size=${size:-20}   # unit: GB

function mk_limit_disk(){
	let 'count=size*4'
	dd if=/dev/zero  of=$diskfile_path/$disk_name  bs=256M  count=$count
	# losetup -f haoran-data-dev-disk
	# mkfs.ext4 /dev/loop0
	mkfs.ext4 $diskfile_path/$disk_name
	mkdir $mount_path/$disk_name
	mount -o loop $diskfile_path/$disk_name  $mount_path/$disk_name
}

echo $diskfile_path/$disk_name  $mount_path/$disk_name
# 将循环设备卸除
# losetup -d /dev/loop0