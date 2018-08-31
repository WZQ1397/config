
注意 `systemd` 的 `autossh.service` 放到 `/lib/systemd/system/autossh.service` 位置

然后执行：
```bash
systemctl enable autossh.service
```

参考这里 http://logan.tw/posts/2015/11/15/autossh-and-systemd-service/
