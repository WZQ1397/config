
安装 Ingest Node GeoIP 和 User Agent 插件。这些插件用来捕获地理位置和浏览器信息，以供可视化组件所用
```
sudo bin/elasticsearch-plugin install ingest-geoip
sudo bin/elasticsearch-plugin install ingest-user-agent
```

设置dashboard
```
./filebeat setup --dashboards
```
启动Filebeat
```
./filebeat -e -c filebeat.yml -d "publish"
```

在Elasticsearch中，索引模板用于定义确定如何分析字段的设置和映射。

Filebeat的推荐索引模板文件由Filebeat包安装，如果你接受filebeat.yml配置文件中的默认配置，Filebeat会在成功连接到Elasticsearch后自动加载模板，如果模板已存在，则除非你配置Filebeat，否则不会覆盖该模板。

配置模板加载
默认情况下，如果启用了Elasticsearch输出，Filebeat会自动加载推荐的模板文件fields.yml，如果要使用默认索引模板，则不需要其他配置，否则，你可以将filebeat.yml配置文件中的默认值更改为：

###### 加载不同的模板
```
setup.template.name: "your_template_name"
setup.template.fields: "path/to/fields.yml"
```
如果模板已存在，则除非你配置Filebeat，否则不会覆盖该模板。

###### 覆盖现有模板
```
setup.template.overwrite: true
```
###### 禁用自动模板加载
```
setup.template.enabled: false
```
如果禁用自动模板加载，则需要手动加载模板。

###### 更改索引名称


默认情况下，当禁用或不支持索引生命周期管理时，Filebeat使用时间系列索引，索引名为filebeat-7.3.0-yyyy.MM.dd，其中yyyy.MM.dd是事件索引的日期，要使用其他名称，请在Elasticsearch输出中设置index选项。
例如：
```
output.elasticsearch.index: "customname-%{[agent.version]}-%{+yyyy.MM.dd}"
setup.template.name: "customname"
setup.template.pattern: "customname-*"
```
如果你使用的是预先构建的Kibana仪表板，请同时设置setup.dashboards.index选项，例如：
```
setup.dashboards.index: "customname-*"
```

手动加载模板
```
./filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
```
或者
```
./filebeat export template > filebeat.template.json
curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_template/filebeat-7.3.0 -d@filebeat.template.json

只导入特定模板
```
./filebeat setup --index-management -E 'setup.dashboards.directory="nginx_kibana"'
```

```
强制Kibana查看最新文档
```curl -XDELETE 'http://localhost:9200/filebeat-*'```



### 格式匹配
###### Java堆栈跟踪
> 格式1

```
Exception in thread "main" java.lang.NullPointerException
        at com.example.myproject.Book.getTitle(Book.java:16)
        at com.example.myproject.Author.getBookTitles(Author.java:25)
        at com.example.myproject.Bootstrap.main(Bootstrap.java:14)
```
> match
```
multiline.pattern: '^[[:space:]]'
multiline.negate: false
multiline.match: after
```

> 格式2

```
Exception in thread "main" java.lang.IllegalStateException: A book has a null property
       at com.example.myproject.Author.getBookIds(Author.java:38)
       at com.example.myproject.Bootstrap.main(Bootstrap.java:14)
Caused by: java.lang.NullPointerException
       at com.example.myproject.Book.getId(Book.java:22)
       at com.example.myproject.Author.getBookIds(Author.java:35)
       ... 1 more
```
> match
```
multiline.pattern: '^[[:space:]]+(at|\.{3})\b|^Caused by:'
multiline.negate: false
multiline.match: after
```

###### 时间戳

```
[2015-08-24 11:49:14,389][INFO ][env                      ] [Letha] using [1] data paths, mounts [[/
(/dev/disk1)]], net usable_space [34.5gb], net total_space [118.9gb], types [hfs]
```
> match

```
multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
multiline.negate: true
multiline.match: after
```

###### 应用事件
```
[2015-08-24 11:49:14,389] Start new event
[2015-08-24 11:49:14,395] Content of processing something
[2015-08-24 11:49:14,399] End event
```
> match

```
multiline.pattern: 'Start new event'
multiline.negate: true
multiline.match: after
multiline.flush_pattern: 'End event'
```

#### 监控Filebeat
第1步：在Filebeat配置文件中添加xpack.monitoring设置。如果你配置了Elasticsearch输出，指定下面最小的配置：

```xpack.monitoring.enabled: true```

如果你配置的是其它输出，比如Logstash，那么你必须指定一些额外的配置项。例如：
```
xpack.monitoring:
  enabled: true
  elasticsearch:
    hosts: ["https://example.com:9200", "https://example2.com:9200"]
    username: beats_system
    password: beatspassword
```
（注意：目前，你必须将监视数据发送到与所有其他事件相同的集群。如果你配置了Elasticsearch输出，请不要在监视配置中指定其他主机。）

第2步：在Kibana中配置监控

