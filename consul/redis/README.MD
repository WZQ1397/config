Author: Zach.Wang

- Redis conf
						master 			slave
sentinel		 		 yes		 	 yes			./redis-sentinel /etc/redis/redis-sentinel.conf
redis-6379		 		 yes		 	 no
redis-6379.conf.slave	 no				 yes
./redis-server /etc/redis/redis-6379.conf

- START CMD:
{{Server_addr}} {{Persistent_Path}} {{conf_file_path}}

/bin/consul agent -advertise=$(ifconfig $(route -n | awk '/^0.0.0.0/ && /UG/ {print $NF}') | grep inet | egrep -v "(inet6|127.0.0.1)" | cut -d ":" -f2 | cut -d " " -f1) -bind=$(ifconfig $(route -n | awk '/^0.0.0.0/ && /UG/ {print $NF}') | grep inet | egrep -v "(inet6|127.0.0.1)" | cut -d ":" -f2 | cut -d " " -f1) -data-dir={{Persistent_Path}} -config-dir={{conf_file_path}} -join {{Server_addr}}