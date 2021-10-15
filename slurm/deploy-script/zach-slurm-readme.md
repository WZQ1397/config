# Writed by zach.wang
# 0. mount disk /DB /DATA9_DB12
  sudo mount -t nfs 172.16.0.122:/DATA9_DB12 /DATA9_DB12
  sudo mount -t nfs 172.16.0.101:/remote-home /DB

# 1. init start a new node
  bash -x docker-install.sh 

# 2. update hosts file for worker node worker name
# [IP]   [hostname1]  [hostname2] ... [hostnameN]  [slurm worker name]
# EG: 192.168.28.28     DB15      DB15-10g         worker01
#       [IP]        [hostname1]  [hostname2]   [slurm worker name]
# check connection for new name
# EG: ping worker01

# 3. deploy slurm worker nodes
  bash -x soft-install.sh

# 4. enter worker node container to check
  sudo docker exec -it [slurm worker name] sinfo

########################
# 5. OTHER OPERATIONS  #
########################

###  5.1 update controller config
#  a) change time limit
#    PartitionName=gpu-v100 Nodes=worker[30] Default=YES MaxTime=6:00:00 State=UP OverSubscribe=YES:8 
#                                                         [change here]
#    MaxTime=[day]:[hour]:[min]
#  b) add new node
#    NodeName=[worker host name] CPUs=64 {[hardware config part]} State=UNKNOWN Gres=gpu:gpu-v100:4
#    ++ Go to new node and use following script to get info of [hardware config part]
>>   bash -x sysinfo.sh
++ docker ps
++ grep worker
++ awk '{print $NF}'
+ id=worker01
+ echo '=======  worker01  =========='
=======  worker01  ==========
+ docker exec -it worker01 slurmd -C
NodeName=worker01 CPUs=16 Boards=1 SocketsPerBoard=1 CoresPerSocket=8 ThreadsPerCore=2 RealMemory=128843
UpTime=7-01:13:25

# copy info 
NodeName=worker01 CPUs=16 Boards=1 SocketsPerBoard=1 CoresPerSocket=8 ThreadsPerCore=2 RealMemory=128843

#  add new node to Partition
#    PartitionName=[PartitionName] Nodes=[worker host name] MaxTime=[time limit] State=UP OverSubscribe=YES:8 

#  c) update config of controller
      kill `ps aux | grep /usr/sbin/slurmctld | grep -v grep | awk '{print $2}'` && /usr/sbin/slurmctld

### 5.2  add user account
# a) GO to /DATA9_DB12/slurm-in-docker/slurm-zach-build/secret/account and COPY following files from DB1
    /etc/group   /etc/passwd  /etc/shadow
# b) GO to /DATA9_DB12/slurm-in-docker/slurm-zach-build/secret/account and UPDATE script
>>  vi run.sh
    item=(user1 user2)
# PS: add user1 and user2 into system 

# c) RUN following script on CONTROLLER AND WORKER17
   cd /.secret/account/
   bash run.sh

### 5.3  set QOS 
# See example in following script
# GOTO DB15
  docker exec -it controller bash
  more /home/config/accountAdd.sh

### 5.4  set default srun config
# --mem
export SLURM_MEM_PER_NODE=4096
# --cpus-per-gpu
export SLURM_CPUS_PER_GPU=4
# -p
export SLURM_PARTITION=debug
# --cpus-per-task
export SLURM_CPUS_PER_TASK=16
# --gpus
export SLURM_GPUS=1

>> add these config to /etc/profile 

### 5.5 set squeue limit
# Admin can see all squeue, User only can see himself

>> worker17 all user only can see himself
>> Admin can login to controller node to see all

# goto DB15
docker exec -it controller squeue

########################
#   6. TROUBLESHOOT    #
########################

### 6.1 reboot worker node failed
a) CHECK whether worker node container is running
b) CHECK /DB or /GPFS whether mounted
c) CHECK /DATA9_DB12 whether mounted
d) GO TO worker container to CHECK DISK whether mounted 
  EG:
root@DB31:/DB/rhome/admin# docker exec -it worker17 df -h
Filesystem                                                Size  Used Avail Use% Mounted on
overlay                                                   916G   24G  846G   3% /
tmpfs                                                      64M     0   64M   0% /dev
tmpfs                                                     504G     0  504G   0% /sys/fs/cgroup
shm                                                        32G  465M   32G   2% /dev/shm
DB12:/DATA9_DB12/slurm-in-docker/slurm-zach-build/secret   40T   14T   27T  35% /.secret
172.16.0.101:/remote-home                                 105T   89T   16T  85% /DB

e) CHECK connection BETWEEN DB15 and worker node
  i) ping check
  root@DB31:/DB/rhome/admin# docker exec -it worker17 ping DB15
  root@DB31:/DB/rhome/admin# docker exec -it worker17 ping controller
  ii) check port
  root@DB31:/DB/rhome/admin# docker exec -it worker17 telnet controller 6817
  Trying 192.168.28.125...
  Connected to controller.
  Escape character is '^]'.
  iii) check iptables ON worker node
  YOU MUST BE ALLOW all slurm ports: 6817-6819, 30000-50000

f) CHECK process of slurm whether is ok, following is the must
  munge    17141  0.0  0.0 248288  4208 ?        Sl   02:06   0:00 /sbin/munged
  root     17303  0.0  0.0 143400  4464 ?        S    02:12   0:00 /usr/sbin/slurmd
  
f.1) Process munged not exist
  EG1: Munge decode failed: Invalid credential
  Use md5sum check whether is now using key, /.secret/munge.key is standard.
  [root@worker01 munge]# md5sum /etc/munge/munge.key 
  c19c1e18c13980ebb1e944bd26e6a948  /etc/munge/munge.key
  [root@worker01 munge]# md5sum /.secret/munge.key 
  c19c1e18c13980ebb1e944bd26e6a948  /.secret/munge.key
 
  EG2: Munge decode failed: Expired credential
  CHECK host and container datetime BETWEEN DB15 AND worker node


f.2) Process slurmd not exist
  EG1: [2021-10-15T02:06:12.056] error: cgroup namespace 'freezer' not mounted. aborting
       [2021-10-15T02:06:12.056] error: unable to create freezer cgroup namespace
       [2021-10-15T02:06:12.056] error: Couldn't load specified plugin name for proctrack/cgroup: Plugin init() callback failed
       [2021-10-15T02:06:12.056] error: cannot create proctrack context for proctrack/cgroup
       [2021-10-15T02:06:12.056] error: slurmd initialization failed
  COPY /.secret/slurm.conf to /etc/slurm/
  RUN /usr/sbin/slurmctld
  #.# IF not WORK, COPY /.secret/opt-conf/cgroup* to /etc/slurm/
  RUN /usr/sbin/slurmctld

  EG2: error: slurm_receive_msg: Zero Bytes were transmitted or received
  GO TO STEP f.1 to check

  EG3: error: slurm_auth_get_host: Lookup failed for 0.0.0.0
  CHECK container HOSTNAME of node

  EG4: fatal: Unable to determine this slurmd's NodeName
  CHECK /etc/slurm/slurm.conf ON worker node of NodeName define part whether has nodes.

  EG5: Reason=gres/gpu count too low
  i) CHECK whether has gres.conf under /etc/slurm
  ii) CHECK whether the same config define on CONTROLLER and worker node
     [root@worker17 worker]# more /etc/slurm/gres.conf 
     Name=gpu Type=gpu-3090 File=/dev/nvidia[0-7]
     [root@controller worker]# grep  NodeName=worker17 /etc/slurm/slurm.conf
     NodeName=worker17 CPUs=128 Boards=1 SocketsPerBoard=2 CoresPerSocket=32 ThreadsPerCore=2 RealMemory=902972 State=UNKNOWN Gres=gpu:gpu-3090:8

   THEY MUST BE THE SAME:  Gres=[name]:[Type]:[COUNT]

  

