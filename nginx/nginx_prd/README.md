这里是nginx的转发配置

将 `custom-error-pages.conf` 文件拷贝到  `/etc/nginx` 目录下

``` bash
cp ./custom-error-pages.conf /etc/nginx
```

将 `_errors` 目录拷贝到  `/usr/share/nginx/html` 目录下

``` bash
cp -R ./_errors /usr/share/nginx/html/
```

这样当后端 tomcat 服务都停止后就会显示自定义的502错误页面。
