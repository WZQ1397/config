
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

###### 测试
```
mysql> show master status;
+------------------+----------+--------------+------------------+----------------------------------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set                            |
+------------------+----------+--------------+------------------+----------------------------------------------+
| mysql-bin.000013 |    27442 |              |                  | 479ffdb7-625c-11e9-a43f-0242ac110007:1-37040 |
+------------------+----------+--------------+------------------+----------------------------------------------+
1 row in set (0.00 sec)

mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000012 |   4582754 |
| mysql-bin.000013 |     27442 |
+------------------+-----------+
2 rows in set (0.00 sec)

mysql> show binlog events in 'mysql-bin.000012' limit 5\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000012
        Pos: 4
 Event_type: Format_desc
  Server_id: 1817
End_log_pos: 120
       Info: Server ver: 5.6.32-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000012
        Pos: 120
 Event_type: Previous_gtids
  Server_id: 1817
End_log_pos: 187
       Info: 479ffdb7-625c-11e9-a43f-0242ac110007:1-30422
*************************** 3. row ***************************
   Log_name: mysql-bin.000012
        Pos: 187
 Event_type: Gtid
  Server_id: 1817
End_log_pos: 231
       Info: SET @@SESSION.GTID_NEXT= '479ffdb7-625c-11e9-a43f-0242ac110007:30423'
*************************** 4. row ***************************
   Log_name: mysql-bin.000012
        Pos: 231
 Event_type: Query
  Server_id: 1817
End_log_pos: 912
       Info: use `approval`; create table inspector_info (
       id VARCHAR(22) BINARY not null,
        created_time TIMESTAMP(3) NULL,
        updated_time TIMESTAMP(3) NULL,
        account varchar(45) DEFAULT NULL COMMENT '用户账号',
        primary key (id)
    ) comment='审批表' engine=InnoDB
*************************** 5. row ***************************
   Log_name: mysql-bin.000012
        Pos: 912
 Event_type: Gtid
  Server_id: 1817
End_log_pos: 956
       Info: SET @@SESSION.GTID_NEXT= '479ffdb7-625c-11e9-a43f-0242ac110007:30424'
```

###### 监控
https://github.com/alibaba/canal/wiki/Prometheus-QuickStart
