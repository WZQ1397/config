启动服务。
```
supervisord -c /etc/supervisord.conf
```
supervisor 常用命令如下：（具体可查看官方文档[3]）
```
supervisorctl status                # Get all process status info.
supervisorctl stop gunicorn         # Stop a process.
supervisorctl start gunicorn        # Start a process.
supervisorctl restart gunicorn      # Restart a process Note: restart does not reread config files.
supervisorctl reread                # Reload the daemon’s configuration files, without add/remove (no restarts).
supervisorctl update                # Reload config and add/remove as necessary
```

修改env(环境变量)
```
[program:superset]
command=python /etc/supervisord/qboxproxy.py -p /home/qboxserver/superset/_package/run/superset.pid -r /home/qboxserver/superset/_package/run/superset.log  -c '/home/qboxserver/superset/venv/bin/python /home/qboxserver/superset/venv/bin/superset runserver'
directory=/home/qboxserver/superset/venv/bin/
priority=999
autostart=true
startsecs=1
autorestart=true
user=qboxserver
environment=SUPERSET_HOME=/home/qboxserver/.superset,SUPERSET_WEBSERVER_PORT=7070,JAVA_HOME=/usr/install/java
```
 保存配置，然后执行
```
supervisorctl stop superset
supervisorctl remove superset
supervisorctl reread
supervisorctl add superset
```