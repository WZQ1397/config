# account => admin:meizhi2018
docker run -d -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /mnt/docker/portainer:/data portainer/portainer
 
# account => zach:meizhi2018
 docker run -u root --name jenkins -d -p 8081:8080 -p 50000:50000 --restart unless-stopped -v /data/jenkins-data:/var/jenkins_home -v /usr/bin/docker:/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -e "JAVA_OPTS=-Duser.timezone=Asia/Shanghai -Xms2048m -Xmx2048m -Xmn512m"  jenkins/jenkins:lts

# account => root:meizhi2018
# 1. vi etc/gitlab.rb 
# change ==>  external_url 'GENERATED_EXTERNAL_URL'
# to ==>  external_url '192.168.1.124:8090' 
# 2. vi /var/opt/gitlab/gitlab-rails/etc/gitlab.yml
#  gitlab:
#    host: 192.168.1.124
#    port: 8090
#    https: false
# 3. Apply gitlab config
# gitlab-ctl reconfigure
docker run -d -p 8443:443 -p 8090:80 --name gitlab --restart unless-stopped -v /data/gitlab-data/etc:/etc/gitlab -v /data/gitlab-data/log:/var/log/gitlab -v /data/gitlab-data/data:/var/opt/gitlab gitlab/gitlab-ce:13.6.2-ce.0

# nginx for NAT of office
docker run -d -p 8080:80 --name nginx-proxy --restart unless-stopped -v /data/nginx-data/conf.d:/etc/nginx/conf.d -v /data/nginx-data/logs:/var/log/nginx nginx

# consul
docker run -d --name zach-consul-1 --restart unless-stopped -v /data/consul-data/config:/consul/config -v /data/consul-data/data:/consul/data -v /home/meizhi2018/consul-client/consul-cert:/consul-cert -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302/udp -p 8302:8302 -p 8400:8400 -p 8500:8500  consul agent -server -bootstrap -ui -client 0.0.0.0 -ui -node ZregisterCenterA -datacenter MZReg

# consul-client-datareturn
docker run --name zach-servermesh-A5 -v /data2:/data/tmp -d -p 8888:8888 zachserver-register:v1.3

# nvidia-docker consul-client-datareturn
docker run --restart unless-stopped --name zach-servermesh-A6 --gpus all -v /data2:/data/tmp -d -p 8888:8888 zachserver-register:v1.5
docker run --restart unless-stopped --name zach-servermesh-A8 --gpus all -v /data2/mldata/database/:/data/minglv -v /data2/mldata/backup/:/data/backup -d -p 8888:8888 zachserver-register:v1.7-ml

# datareturn-server
docker run --restart unless-stopped -d --name zach-datareturn-1 -p 10000:10000 nginx-upload:v1.0

# docker-slim

docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock dslim/docker-slim build  zachserver-register:v1.3 --http-probe=false --tag zachserver-register:v1.3-slim

# conatiner monitor
docker run --restart unless-stopped -v/:/rootfs:ro -v /var/run:/var/run:ro -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro -v /dev/disk/:/dev/disk:ro  -p 8088:8080 -d --name=cadvisor google/cadvisor

# minio server
docker run -d -p 19000:9000 --name zach-oss-server -e "MINIO_ACCESS_KEY=admin" -e "MINIO_SECRET_KEY=meizhi2018" -v /data1/minio-data/data:/data -v /data1/minio-data/config:/root/.minio minio/minio server /data

# upload project for cctv
docker run --restart unless-stopped -d --name zach-blobupload-front -p 10001-10002:80-81 -p 20000-20099:100-199 -v /data1/zach-blobdata-upload/nginx-config:/etc/nginx/conf.d -v /data1/zach-blobdata-upload/front-page:/data/web -v /data1/zach-blobdata-upload/storage-data:/storage-data nginx:1.18-alpine 

docker run --restart unless-stopped -d --name zach-blobupload-backend -p 8100:8000 -v /data1/zach-blobdata-upload/backend-service:/data/code -e TZ="Asia/Shanghai" -v /etc/localtime:/etc/localtime:ro python:3.6.12 sleep 100000000

# vnc
 docker run -d --shm-size=256m -p 5902:5901 -p 6901:6901 -e VNC_PW=meizhi2018 --user=$(id -u):$(id -g) consol/centos-xfce-vnc
 sudo docker run -d --name ubuntu-desktop-lxde-vnc -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=abcd@1234 -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc

# cctv-news-detect
docker run --restart unless-stopped -itd --name zach-cctv-news-detect-landmark-v1.5-test --gpus all -v /project-code-on-166/zach-cctv-news-detect-landmark-test:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-news-landmark-detect:v1.5
 docker run --restart unless-stopped -itd --name zach-cctv-news-detect-event_detection-v1.5-test --gpus all -v /project-code-on-166/zach-cctv-news-detect-event_detection-test:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-news-event-detect:v1.5
 docker run --restart unless-stopped -itd --name zach-cctv-news-detect-weapon-v1.5-test --gpus all -v /project-code-on-166/zach-cctv-news-detect-weapon-test:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-news-weapon-detect:v1.5
 docker run --restart unless-stopped -itd --name zach-cctv-news-detect-flag-v1.5-test --gpus all -v /project-code-on-166/zach-cctv-news-detect-flag-test:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-news-flag-detect:v1.5
 docker run --restart unless-stopped -itd --name zach-cctv-news-face-modelA-v1.1-test --gpus all -v /project-code-on-166/zach-cctv-news-face-video-compose:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-item-detect-base:cuda-10.2-v1.1  tail -f /dev/null
 docker run --restart unless-stopped -itd --name zach-cctv-news-face-modelB-v1.1-test --gpus all -v /project-code-on-166/zach-cctv-news-face-video-compose:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-item-detect-base:cuda-10.2-v1.1  tail -f /dev/null
 docker run --restart unless-stopped -itd --name zach-cctv-news-face-ocr-v1.1-test  --mac-address 00:00:00:00:00:66 --gpus all -v /project-code-on-166/zach-cctv-news-face-video-compose-faceocr:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-item-detect-base:cuda-10.2-v1.1  tail -f /dev/null
# video-enhancer
 docker run --restart unless-stopped -itd --name zach-cctv-video-enhancer-online-pretreatment --gpus all -v /data1/project-code/zach-cctv-video-enhancer-online-pretreatment:/data/code -v /data1/storage-data:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro zach-cctv-video-enhancer-online-base tail -f /dev/null
 docker run --restart unless-stopped -itd --name zach-cctv-video-enhancer-online-denoising --gpus all -v /data1/project-code/zach-cctv-video-enhancer-online-denoising:/data/code -v /data1/storage-data:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro video-enhancer-model-service-oldcode:v1.4-cuda11.2 tail -f /dev/null
 docker run --restart unless-stopped -itd --name zach-cctv-video-enhancer-online-color --gpus all -v /data1/project-code/zach-cctv-video-enhancer-online-color:/data/code -v /data1/storage-data:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro video-enhancer-model-service-oldcode:v1.4-cuda11.2 tail -f /dev/null
 docker run --restart unless-stopped -itd --name zach-cctv-video-enhancer-online-compose --gpus all -v /data1/project-code/zach-cctv-video-enhancer-online-compose:/data/code -v /data1/storage-data:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro video-enhancer-model-service-oldcode:v1.4-cuda11.2 tail -f /dev/null

 # donghaitianpu-ocr 
docker run  --network=host --restart unless-stopped -itd --name donghaitianpu-ocr-backend -v /data1/storage-data/code/donghaitianpu-ocr:/data/code -v /data1/zach-blobdata-upload/storage-data:/storage-data -p 10010-10015:8000-8005 --gpus=all -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro python:3.8.6 tail -f /dev/null

docker run --restart=unless-stopped --name zach-mz-mysql -itd -v /data2/mysql-data:/var/lib/mysql -e "MYSQL_ROOT_PASSWORD=zachmzcctv" -e "TZ=Asia/Shanghai"  -p 3309:3306 mysql:5.7

docker run -itd --name zach-donghaitianpu-defect-api -v /data1/storage-data/code/zach-donghaitianpu-defect-api:/data/code -v /data1/zach-blobdata-upload/storage-data/zach-donghaitianpu-defect-api:/data/defect/static -e "TZ=Asia/Shanghai" python:3.6.12 tail -f /dev/null

# docker save
#  for x in `docker ps | awk '/park/{print $NF}'`; do IMG=`docker ps | grep $x | awk '{print $2}' | sed 's/reg.devmz.cn:5845/zach/g'` ;docker commit -a 'zach.wang' $x $IMG; docker save $IMG | gzip > $x.tar.gz; done

 docker run --restart unless-stopped -itd --name zach-cctv-news-face-ocr-v1.2-test  --mac-address 00:00:00:00:00:88 --gpus all -v /project-code-on-166/zach-cctv-news-face-video-compose-faceocr-2:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro python:3.7  tail -f /dev/null

 docker run --restart unless-stopped -itd --name zach-cctv-news-face-detect-backend-test-v1.0 --gpus all -v /data1/project-code/zach-cctv-news-face-detect-backend-test-v1.0:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -p 10015:8000 -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro cctv-news-face-detect:v1.0

 docker run --restart unless-stopped -itd --name zach-cctv-news-face-video-compose-v1.0 --gpus all -v /project-code-on-166/zach-cctv-news-face-video-compose:/data/code -v /zach-cctv-nfs-local-test-on-166:/storage-data -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro cctv-news-face-detect:v1.1

 # edge box system
 sudo docker run --restart unless-stopped -itd --name edge-device-manager --gpus all -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro -v /data1/project-code/edge-device-manager:/data/code -v /data3:/storage-data  -p 14001:8000 edge-device-manager:v1.0 tail -f /dev/null
