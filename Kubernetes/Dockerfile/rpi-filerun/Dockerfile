FROM resin/rpi-raspbian:buster
MAINTAINER j0ck1e

RUN apt-get update && apt-get install -y php-mysql php-fpm php-mbstring \
    php-zip php-curl php-gd php-ldap php-xml unzip nginx pngquant \
    imagemagick ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir /data && chown -R www-data:www-data /data

# install IonCube
RUN curl -O http://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_armv7l.tar.gz && \
    tar -zxvf ioncube_loaders_lin_armv7l.tar.gz && \
    mv "ioncube/ioncube_loader_lin_7.2.so" /usr/lib/php/20170718/ && \
    echo "zend_extension=ioncube_loader_lin_7.2.so" >> \
    /etc/php/7.2/fpm/conf.d/00_ioncube.ini && \
    rm -rf ioncube_loaders_lin_armv7l.tar.gz && rm -rf ioncube

COPY filerun.ini /etc/php/7.2/fpm/conf.d/00_filerun.ini

# configure nginx
RUN echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;'>>\
    /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/sites-enabled/default && mkdir /run/php && \
    rm -rf /var/www/html/*

COPY filerun.conf /etc/nginx/conf.d/filerun.conf

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80
VOLUME ["/data", "/var/www/html"]
ENTRYPOINT ["/entrypoint.sh"]
