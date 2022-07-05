#!/bin/bash
##set Persistence-M for nvidia gpu driver(eg. nvidia-smi -pm 1)

dir=$(cd `dirname $0`;pwd)

is_nv_gpu_host()
{
    gpu_info=$(lspci | grep NVIDIA)
    if [ ${#gpu_info} -gt 0 ];then
        echo "nvidia gpu host"
        return 1
    fi  

    return 0
}

is_gpu_driver_installed()
{
    driver_info=$(lsmod | grep nvidia)
    if [ ${#driver_info} -gt 0 ];then
        return 1
    fi  
    
    return 0
}

is_nv_gpu_host
if [ $? -eq 0 ];then
    echo "not nvidia gpu host. exit"
    exit 0
fi

is_gpu_driver_installed
if [ $? -eq 0 ];then
    echo "gpu driver not installed. exit"
    exit 0
fi

command -v nvidia-smi >/dev/null 2>&1 && { nvidia-smi -pm 1; echo "set Persistence-M for nvidia gpu driver success";} || { echo "no nvidia-smi command. exit."; exit 1;} 

