#!/bin/bash

# Version 1.0
# Function: Check the router application staus
# Script Name: monitor_vpn_to_zach.sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/aws/bin:/root/bin
DATE=`date "+%Y%m%d"`
year=`date "+%Y"`
basicpath="/home/zyadmin/"
logfile=$basicpath$DATE-monitor.log
mail_list=("zach@zach.cn")
echo `date "+%T"` >> $logfile
echo `service ipsec status | grep tunnels` >> $logfile
find $basicpath -name "$year*-monitor.log" -mtime +2 |xargs rm -rf  
if [ `service ipsec status | grep tunnels | awk '{print $1}'` -gt 0 ];then
	echo "Ipsec vpn check Successfully" >> $logfile
else
	for mail in ${mail_list[*]}
		do
			echo "DEV VPN WAS DOWN!" |mail -s "TS DEV VPN ERROR " $mail
		done
fi