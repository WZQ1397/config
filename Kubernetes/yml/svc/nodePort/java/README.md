$ sudo docker run --name mysql -p 12345:3306 -v $DOCKER_RUNTIME/mysql/data:/var/lib/mysql -v $DOCKER_RUNTIME/mysql/conf:/etc/mysql/conf.d -d mysql:5.6.35

