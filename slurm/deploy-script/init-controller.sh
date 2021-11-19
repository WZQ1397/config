cp -rfv /.secret/*.conf /etc/slurm
cp -rfv /.secret/opt-conf/* /etc/slurm
cp -rfv /.secret/munge.key /etc/munge/
sudo -u munge /sbin/munged
munge -n
munge -n | unmunge
remunge
slurmctld
