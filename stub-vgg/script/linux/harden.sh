/bin/find /var/log -type f -exec chmod g-wx,o-rwx {} +
/bin/cat /etc/passwd | /bin/awk -F ':' '{print $1}' | while read USER; do /usr/bin/chage --mindays 7 --warndays 7 $USER; done;
/bin/chown root:root /etc/passwd-
/bin/chmod 600 /etc/passwd-
/bin/chown root:root /etc/shadow-
/bin/chmod 600 /etc/shadow-
/bin/chown root:root /etc/group-
/bin/chmod 600 /etc/group-
/bin/chown root:root /etc/crontab
/bin/chmod og-rwx /etc/crontab
/bin/chown root:root /etc/cron.hourly
/bin/chmod og-rwx /etc/cron.hourly
/bin/chown root:root /etc/cron.daily
/bin/chmod og-rwx /etc/cron.daily
/bin/chown root:root /etc/cron.weekly
/bin/chmod og-rwx /etc/cron.weekly
/bin/chown root:root /etc/cron.monthly
/bin/chmod og-rwx /etc/cron.monthly
/bin/chown root:root /etc/cron.d
/bin/chmod og-rwx /etc/cron.d
/bin/chmod og-rwx /etc/cron.allow
/bin/chmod og-rwx /etc/at.allow
/bin/chown root:root /etc/cron.allow
/bin/chown root:root /etc/at.allow
/bin/chown root:root /nas/*
/bin/mkdir -p /root/bin/
/bin/chmod 700 /root/bin
