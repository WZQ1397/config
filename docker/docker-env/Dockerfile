FROM python:3.9
LABEL MAINTAINER ZACH.WANG
ENV PYTHON_VERSION 3.9
ENV PROJ ansible
ENV CN_REPO_URL mirrors.aliyun.com
ENV WORK_PATH ~
ENV RUNNING_ENV dev
ENV PKG_NAME zach-${PROJ}-py${PYTHON_VERSION}-main.tar.gz
RUN sed -i "s/security.debian.org/${CN_REPO_URL}/g" /etc/apt/sources.list && \
    sed -i "s/deb.debian.org/${CN_REPO_URL}/g" /etc/apt/sources.list
RUN apt update -y && apt install -y openssh-server cron curl lsof vim jq
# COPY ${RUNNING_ENV}/${PKG_NAME} ${WORK_PATH}
RUN apt clean \
			&& rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp* \
			&& echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \ 
            && echo "root:zach" | chpasswd && mkdir /run/sshd
EXPOSE 22
CMD [ "/usr/sbin/sshd", "-D" ]
