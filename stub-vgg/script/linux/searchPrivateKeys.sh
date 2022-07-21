#!/bin/sh

# AWB - This script will get a list of all users using getent,
# extract their home directory from the list, and
# search for private keys without any password.
# It will log any found to syslog which will show up in splunk
# Sample splunk query: index=os "private key"

# if run with the argument "global", it will run the same find command
# from the root of the file system (/) NOT including any NAS file systems

# if run with the argument "nas", it will run the same find command from
# the root of the file system (/) including any NAS file systems
#	-NOTE: Probably best to only run this once per week against NAS
#	-NOTE: Should run this against NAS on a machine that is not being
#		root squashed.


search()
{
	local topdir="$1"
	shift
	local findArgs="$*"
	[ "$verbose" = true ] && echo $topdir
	find $topdir -type f $findArgs \
		-exec grep -l -- '-----BEGIN.*PRIVATE KEY-----' {} \; |
		grep -v "searchPrivateKeys.sh" |
	while read privFile
	do
		[ "$verbose" = true ] && echo $privFile
		owner=$(ls -l $privFile |awk '{print $3}')
		dekinfo=$(grep "^DEK-Info" $privFile)
		if [ -z "$dekinfo" ]
		then
			[ "$verbose" = true ] && echo "calling -lf"
			dekinfo=$(ssh-keygen -lf $privFile |sed -e "s/:.*//")
		fi
		# kind of a hack to find out if it has a passphrase
		[ "$verbose" = true ] && echo "calling -yf"
		#ssh-keygen -yf $privFile <<</dev/null >/dev/null
       	        setsid </dev/null 2>&1 env -i ssh-keygen -y -f $privFile | grep -q  'Enter passphrase'
		if [ $? -ne 0 ]
		then
			#decryption worked, so it doesn't have passphrase
			logger -p $LOGLEVEL "private key file without passprhase
: $privFile owner: $owner $dekinfo"
		else
			logger -p $LOGLEVEL "private key file with passprhase: $
privFile owner: $owner $dekinfo"
		fi
	done
}
############# main

#ensure that the user running the script is the same as the one passed
# to the function
checkUser()
{
	local USER=$1
	local myid=`id |sed -e "s/) .*//" -e "s/.*(//"`
	if [ "$myid" = "$USER" ]
	then
			:
	else
		echo "Script $0 can only be run as $USER" >&2
		exit 1
	fi
}

checkUser root
LOGLEVEL="authpriv.1"

case "$1" in
TEST)
	# everything including nas mounts
	verbose=true
	topdir=/home/andbarclay
	search "$topdir"
	;;
global)
	# everything NOT including nas mounts
	topdir=/
	search "$topdir" -fstype local
	;;
nas)
	# everything including nas mounts
	topdir=/
	search "$topdir"
	;;
*)
	# only home dirs
	getent passwd |while read line
	do
		user=$(echo $line |awk -F: '{print $1}')
		homedir=$(echo $line |awk -F: '{print $6}')
		if echo $homedir |grep "/nas" >/dev/null
		then
			continue
		fi
		if [ "$homedir" = "/" ] || [ ! -d $homedir ]
		then
			continue
		fi
		search "$homedir"
	done
	;;
esac
