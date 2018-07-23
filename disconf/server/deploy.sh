#!/bin/bash
#	1. $ONLINE_CONFIG_PATH 	: java web online dir
#	2. $WAR_ROOT_PATH 		: java web war package
ONLINE_CONFIG_PATH=/home/work/dsp/disconf-rd/online-resources
WAR_ROOT_PATH=/home/work/dsp/disconf-rd/war
export ONLINE_CONFIG_PATH
export WAR_ROOT_PATH
cd disconf-web
sh deploy/deploy.sh