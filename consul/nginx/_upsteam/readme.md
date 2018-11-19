- init template file:
[root@master ~]# consul-template -consul 127.0.0.1:8500 -template item.consul.ctmpl:/etc/nginx/conf.d/default.conf:"/usr/sbin/nginx -s reload"

- register service
[root@master conf.d]# curl -X PUT http://127.0.0.1:8500/v1/catalog/register -d'{"Datacenter": "dc1", "Node":"tomcat1", "Address":"192.168.113.175","Service": {"Id" :"192.168.113.175:8080", "Service": "tomcat","tags": ["dev"], "Port": 8080}}'
[root@master conf.d]# curl -X PUT http://127.0.0.1:8500/v1/catalog/register -d'{"Datacenter": "dc1", "Node":"tomcat2", "Address":"192.168.113.176","Service": {"Id" :"192.168.113.176:8080", "Service": "tomcat","tags": ["dev"], "Port": 8080}}'



