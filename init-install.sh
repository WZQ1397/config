function centos_install_docker(){
	sudo yum install -y yum-utils device-mapper-persistent-data lvm2
	sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	sudo yum makecache fast
	sudo yum -y install docker-ce
	sudo service docker start
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
	sudo tee /etc/yum.repos.d/nvidia-docker.repo

	DIST=$(sed -n 's/releasever=//p' /etc/yum.conf)
	DIST=${DIST:-$(. /etc/os-release; echo $VERSION_ID)}
	sudo yum makecache


	sudo yum install -y nvidia-docker2

	sudo systemctl restart docker
}


function ubuntu_install_docker(){
	sudo apt-get update
	sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get -y update
	sudo apt-get -y install docker-ce
	sudo apt install nfs-kernel-server nfs-common lrzsz telnet iftop python3-pip htop tree -y
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

	sudo apt-get update

	sudo apt-get install -y nvidia-docker2

	sudo systemctl restart docker

}

function mkdisk(){
	# parted /dev/vdb mklabel gpt
	# parted /dev/vdb mkpart primary 0 20G
	# parted /dev/vdb p
	# mkfs -t ext4 /dev/sdb1
	# pvcreate /dev/sdb1
	# vgcreate vg1-zach /dev/sdb1
	# lvcreate -L 2000G -n lv1-zach vg1-zach
	# mkfs.ext4 /dev/vg1-zach/lv1-zach
	# blkid /dev/vg1-zach/lv1-zach

	parted /dev/$1 mklabel gpt
	parted /dev/$1 mkpart primary 0 537G
	parted /dev/$1 p
	pvcreate /dev/$11
	vgcreate vg-$1-zach /dev/$11
	lvcreate -L 537G -n $1-lv-zach vg-$1-zach
	mkfs.ext4 /dev/vg-$1-zach/$1-lv-zach
	blkid /dev/vg-$1-zach/$1-lv-zach

}

function resize_disk(){
	current_disk=`parted /dev/vdb p | grep "Disk /dev/vdb:" | awk '{print $NF}'`
	parted /dev/vdc resizepart 1 $current_disk
	partprobe
	pvresize /dev/vdc1
	pvscan
	lvextend -L +150g /dev/vg2-zach/lv2-zach
	resize2fs /dev/vg2-zach/lv2-zach
}

