#!/bin/bash
version=7.3.1.1-7651b7244cf2
fqdn_random_hour=2
current_hour=`/bin/date +'%k' | xargs`

if [[ $current_hour != $fqdn_random_hour ]]; then
  echo "Not the correct hour, is $current_hour but must be $fqdn_random_hour."
  exit 0
fi

if [[ $(hostname -s) = *log* ]]; then
  # This is a Splunk server
  exit 0
fi

installed_version=`/bin/rpm -qa splunkforwarder --queryformat '%{version}-%{release}'`
if [[ $installed_version != "$version" ]]; then
  yum clean all
  /etc/init.d/splunk stop
  pkill -9 splunkd
  sleep 5
  yum remove splunkforwarder -y
  yum install splunkforwarder-$version -y --disablerepo=* --enablerepo=core-0,*dates,splunk
  /opt/splunkforwarder/bin/splunk start --accept-license --no-prompt --answer-yes
  pkill -9 splunkd
  sleep 2
  /opt/splunkforwarder/bin/splunk start --no-prompt --answer-yes
  chown root:root /opt/splunkforwarder/etc/system/local/deploymentclient.conf
else
  echo "Already the correct version of $version."
  exit 0
fi
