测试
``` logrotate -d /etc/logrotate.d/log-file ```
 强制执行，如果轮询的条件不满足，上面的命令不会执行，这个时候可以用下面这条命令来达到效果
 ```logrotate -vf /etc/logrotate.d/log-file ```
 -f 强制轮询  -v 打印logrotate  日志
