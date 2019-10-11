# HOW TO 
# SERVER 
# rsync.secrets format:
# username:password

echo "rsync --daemon" >> /etc/rc.local
echo "zach:123" > /etc/rsync.secrets
chmod 600 /etc/rsync.secrets

# CLIENT
# rsync.key format:
# password
echo "123" > /etc/rsync.key
chmod 600 /etc/rsync.key
rsync -zrtopg  --progress --delete --password-file=/etc/rsync.key /zach_data/bak  SvcCWRSYNC@172.10.102.10::cmdb