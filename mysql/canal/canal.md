
###### 开启MySQL的binlog日志
1. 修改/etc/my.cnf
```
log-bin=/var/lib/mysql/mysql-bin # binlog 日志存放路径
binlog-format=ROW
server_id=1 # 指定当前机器的服务 ID(如果是集群，不能重复)
```
启用mysql多节点解析
```
log_slave_updates=true ##这个配置一定要打开
```

2. 配置完毕之后，登陆MySQL，输入如下命令
```
mysql> show variables like 'binlog_format';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| binlog_format | ROW   |
+---------------+-------+
mysql> show variables like 'log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+
```

3. 配置目标mysql上的canal用户
```
mysql -uroot -p
> 
CREATE USER canal IDENTIFIED BY 'canal';
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
FLUSH PRIVILEGES;
```

4. 重启目标mysql服务

###### 安装启动canal
1. 下载
https://github.com/alibaba/canal/releases

2. 修改配置文件instance.properties和canal.properties
> instance.properties配置定义优先级高于canal.properties

3. 开启canal服务
```
bin/startup.sh
```


####### 监控
https://github.com/alibaba/canal/wiki/Prometheus-QuickStart
