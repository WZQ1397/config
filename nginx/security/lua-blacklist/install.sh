wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar -zxvf LuaJIT-2.0.5.tar.gz
cd LuaJIT-2.0.5
make -j8
make install -j8
export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.1
http://nginx.org/download/nginx-1.20.2.tar.gz
tar -zxvf nginx-1.20.2.tar.gz
cd nginx-1.20.2
./configure  --user=www --group=www \
--prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_sub_module \
--with-http_realip_module \
--add-module=src/misc/ngx_devel_kit-master  \
--add-module=src/misc/set-misc-nginx-module-master \
--add-module=src/misc/echo-nginx-module-master \
--with-ld-opt=-Wl,-rpath,/usr/local/lib  \
--add-module=/opt/downloads/lua-nginx-module-master
make -j8
make install -j8
wget https://github.com/openresty/lua-resty-redis/archive/master.zip
mv master.zip lua-resty-redis.zip
unzip lua-resty-redis.zip
cd lua-resty-redis-master/
mv lua-resty-redis-master lua-resty-redis
mv lua-resty-redis /usr/local/nginx/lua
