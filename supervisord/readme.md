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