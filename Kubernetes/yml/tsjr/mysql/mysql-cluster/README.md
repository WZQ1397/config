准备mysql主从的镜像环境
dockerfile、docker-entrypoint.sh 文件下载地址如下
https://github.com/docker-library/mysql/tree/master/5.7
由于我们要配置mysql主从，所以需要对dockerfile、docker-entrypoint.sh 文件做一点的修改，主要是在mysql主从配置部分。

准备master的镜像
将Dockerfile, docker-entrypoint.sh复制一份用于build master镜像文件。
在Dockerfile中添加如下内容，将mysql master的server-id设置为1
--------------------- 
准备slave的镜像
将Dockerfile, docker-entrypoint.sh复制一份用于build slave镜像文件。
在Dockerfile中添加如下内容，将mysql slave的server-id设置为一个随机数

ref:https://blog.csdn.net/weixin_34220963/article/details/85056139