#!/bin/bash

if [ ! -n "$1" ] ;then
    installer=NVIDIA-Linux-x86_64-no-compat32.run
else
    installer=$1
fi
distribution_supported=0

nvidia_devices=$(lspci -d 10de:)
if [ "$nvidia_devices" == "" ]; then
	echo "make sure there is a nvidia pci device"
	exit -1
fi

if [ $(id -u) != 0 ]; then
	echo "must be root"
	exit -1
fi

cd /usr/local/qcloud/
lsb_release -a 2>&1 | grep "Ubuntu" &> /dev/null
# Ubuntu Distribution
if [ $? == 0 ]; then
	# Only support Ubuntu version later or equal 18
	ubuntu_major_version=$(lsb_release -a| grep -i "release" | cut -d':' -f2 | cut -d'.' -f1)
	if [ $ubuntu_major_version -gt 14 ]; then
		distribution_supported=1
		wait_time=0
		while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
			echo "Waiting for /var/lib/dpkg/lock to finish..." 
			if [ $wait_time -gt 300 ]; then
				echo "Can not get /var/lib/dpkg/lock..."
				echo "### end ###"
				exit -1
			fi
			sleep 1
			wait_time=$(($wait_time+1))
		done 
		wait_time=0
		while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
			echo "Waiting for /var/lib/apt/lists/lock to finish..." 
			if [ $wait_time -gt 300 ]; then
				echo "Can not get /var/lib/apt/lists/lock..."
				echo "### end ###"
				exit -1
			fi
			sleep 1
			wait_time=$(($wait_time+1))
		done
		wait_time=0
		while true; do
			ret=0
			apt-get update
			ret=$(($ret+$?))
			apt-get -y install build-essential
			ret=$(($ret+$?))
			apt-get -y install dkms
			ret=$(($ret+$?))
			apt-get -y install gcc
			ret=$(($ret+$?))

			if [ $ret == 0 ]; then
				break
			fi
			echo "Waiting for install dkms..." 
			if [ $wait_time -gt 30 ]; then
				echo "Can not install dkms..."
				echo "### end ###"
				exit -1
			fi
			sleep 5
			wait_time=$(($wait_time+1))
		done
		lsmod | grep nouveau
		if [ $? == 0 ]; then
			rmmod nouveau
			rm -rf /lib/modules/$(uname -r)/kernel/drivers/gpu/drm/nouveau/nouveau.ko
			echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf
			echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf
			update-initramfs -u
		fi
	fi
fi

cat /etc/redhat-release | grep CentOS &> /dev/null
# CentOS/tlinux Distribution
if [ $? == 0 ]; then
	if [ -f /etc/tlinux-release ]; then
		# Only support tlinx 2.4
		if [ `grep -o "[[:digit:]]\{1,\}\.[[:digit:]]\{1,\}" /etc/tlinux-release` = 2.4 ]; then
			distribution_supported=1
			yum -y groupinstall "Development Tools"
			yum -y install dkms
		fi
	else
		# Only support Centos7.x
		cat /etc/redhat-release | grep "CentOS Linux release 7" &> /dev/null
		if [ $? == 0 ]; then
			distribution_supported=1
			yum -y groupinstall "Development Tools"
			yum -y install dkms
		fi
	fi
fi

if [ x$distribution_supported != x1 ]; then
        echo "unsupported distribution, must be ubuntu18.x centos7.x or tlinux2.4"
        exit -1
fi

wait_time=0
get_driver=0
while [ $wait_time -lt 10 ]; do
	wget "http://mirrors.tencentyun.com/install/GPU/$installer" -O /tmp/$installer
	if [ $? == 0 ]; then
		get_driver=1
		break;
	fi
	wait_time=$(($wait_time+1))
	sleep 1
done
if [ x$get_driver != x1 ]; then
        echo "download driver file failed, please check the input,url oand network"
        exit -1
fi

chmod u+x /tmp/$installer
/tmp/$installer --ui=none --disable-nouveau --no-install-libglvnd --dkms -s
echo "install nvidia driver finished"
rm -rf /tmp/$installer

command -v nvidia-smi >/dev/null 2>&1 && { nvidia-smi -pm 1; echo "set Persistence-M for nvidia gpu driver success";} || { echo "no nvidia-smi command. exit."; exit 1;} 

# restart barad
if [ -d /usr/local/qcloud/monitor/barad/ ]; then
    if [ $(ps -ef | grep barad_agent | wc -l) -gt 1 ]; then
        /usr/local/qcloud/monitor/barad/admin/stop.sh
        /usr/local/qcloud/monitor/barad/admin/trystart.sh
        echo "barad agent restarted"
    fi
fi
