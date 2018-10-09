#!/bin/bash
# Author: Zach.Wang

#https://rundeck.org/3.0.0/man5/aclpolicy.html
function init_user()
{
	userlist=$1
	cat $userlist | while read username
	do
		cat username.aclpolicy.tmpl > $username.aclpolicy
		sed -i 's/username/${username}' $username.aclpolicy
		echo $username "created!"
	done
}

init_user $1
	
