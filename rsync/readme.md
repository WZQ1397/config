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

#### 示例：并发5个rsync进程从超算平台个人目录~/data下载数据到外部主机~/download/路径下
$ ssh expuser01@data.hpc.sjtu.edu.cn ls /lustre/home/acct-exp/expuser01/data/ > remote_list.txt
$ cat remote_list.txt
  001.dat
  002.dat
  003.dat
  004.dat
  005.dat
$ cat remote_list.txt | xargs --max-args=1 --max-procs=5 --replace=% rsync --archive --partial expuser01@data.hpc.sjtu.edu.cn:/lustre/home/acct-exp/expuser01/data/% ~/download/

### 断点续传
##### 使用 rsync 指定 --partial 选项来保留传输未完成的文件
[liuhy@laptop Downloads]$ rsync -avz --partial --progress gcc-7.3.0.tar.xz server:
sending incremental file list
gcc-7.3.0.tar.xz
     36,208,640  57%   11.43MB/s    0:00:02  ^CKilled by signal 2.
                                           # ^ 使用 Ctrl+C 强制终止
rsync error: unexplained error (code 255) at rsync.c(638) [sender=3.1.2]
##### 指定 --append 选项来传输未完成的文件
[liuhy@laptop Downloads]$ rsync -avz --append --progress gcc-7.3.0.tar.xz server:
sending incremental file list
gcc-7.3.0.tar.xz
     62,462,388 100%   11.71MB/s    0:00:02 (xfr#1, to-chk=0/1)

sent 26,481,503 bytes  received 34 bytes  7,566,153.43 bytes/sec
total size is 62,462,388  speedup is 2.36
  # ^ 注意这是从 57% 开始传的，sent 和 total size 不一样。