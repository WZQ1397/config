
在 `10.8.229.100` 上启动 `mongo1.xjsft.gov.cn`

```bash
docker run --name mongo1.xjsft.gov.cn --hostname mongo1.xjsft.gov.cn -v /data/mongo1.xjsft.gov.cn:/data/db -p 10.8.229.100:27017:27017 -d mongo:latest --replSet mongors
```

在 `10.8.229.101` 上启动 `mongo2.xjsft.gov.cn`

```bash
docker run --name mongo2.xjsft.gov.cn --hostname mongo2.xjsft.gov.cn -v /data/mongo2.xjsft.gov.cn:/data/db -p 10.8.229.101:27017:27017 -d mongo:latest --replSet mongors
```

在 `10.8.229.102` 上启动 `mongo3.xjsft.gov.cn`

```bash
docker run --name mongo3.xjsft.gov.cn --hostname mongo3.xjsft.gov.cn -v /data/mongo3.xjsft.gov.cn:/data/db -p 10.8.229.102:27017:27017 -d mongo:latest --replSet mongors
```

在 `10.8.229.103` 上启动 `mongobak.xjsft.gov.cn`

```bash
docker run --name mongobak.xjsft.gov.cn --hostname mongobak.xjsft.gov.cn -v /data/mongobak.xjsft.gov.cn:/data/db -p 10.8.229.103:27017:27017 -d mongo:latest --replSet mongors
```

登录到mongo,初始化集群

```bash
mongo -host 10.8.229.100
```

```javascript
rs.initiate({_id:"mongors", members : [{_id:0, host:"10.8.229.100:27017"}]});
```

再添加成员

```javascript
rs.add({_id: 1, host: "10.8.229.101:27017"});
```

```javascript
rs.add({_id: 2, host: "10.8.229.102:27017"});
```

添加一个延迟10小时的备份节点

```javascript
rs.add({_id: 3, host: "10.8.229.103:27017", priority: 0, hidden: true, slaveDelay: 36000});
```

在 `10.8.229.100` 上启动tomcat

```bash
docker run --restart always --name lg.xjsft.gov.cn --hostname lg.xjsft.gov.cn -m 10g -v /data/lg.xjsft.gov.cn/apps:/apps -v /data/lg.xjsft.gov.cn/appdata:/appdata -v /data/lg.xjsft.gov.cn/logs:/usr/local/tomcat/logs -p 8080:8080 -p 9876:9876 -d homolo/tomcat:latest
```
