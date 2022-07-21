#!/bin/bash
# This should fix 100% of Puppet agent problems.

# Kill any running Puppet agents
kill $(pgrep puppet | grep -v ^$$\$)
# Remove any Puppet packages
yum remove puppet puppet-agent -y --disablerepo=* --enablerepo=puppetlabs*
# Remove any Puppet repos
rm -rf /etc/puppetlabs/puppet /var/lib/puppet /etc/yum.repos.d/puppetlabs*

# Add new puppetlabs-pc1 repo
OSVERS=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release) | head -c 1`
printf "[puppetlabs-pc1-el${OSVERS}]\nenabled=1\nname=puppetlabs-pc1-el${OSVERS}\nbaseurl=http://cob001.com/cobbler/repo_mirror/puppetlabs-pc1-el${OSVERS}\npriority=5\ngpgcheck=0\n" | tee /etc/yum.repos.d/puppetlabs-pc1-el${OSVERS}.repo

# Install new Puppet agent
yum clean all
yum install puppet-agent --disablerepo=* --enablerepo=puppetlabs* -y
# Generate a new certificate
/opt/puppetlabs/bin/puppet certificate generate $(hostname) --server=puppet.zachprod.com --ca-location=remote --ca_server=puppetca.zachprod.com
# First run, configure the Puppet agent. Then do a full Puppet run.
/opt/puppetlabs/bin/puppet agent -t --tags Puppet::Agent,monit --server puppet.zachprod.com --ca_server puppetca.zachprod.com --environment production --no-noop
/opt/puppetlabs/bin/puppet agent -t --tags Puppet::Agent,monit --server puppet.zachprod.com --ca_server puppetca.zachprod.com --environment production --no-noop
