while true
do
  [[ `ps aux | grep slurmctld | grep -v grep` -ne 1 ]] && slurmctld || echo ok
  sleep 30
done
