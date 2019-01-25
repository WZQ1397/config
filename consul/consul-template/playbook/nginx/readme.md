# 1. start consul and consul-template
consul-template -template "/root/consul/playbook/nginx/local/local-nginx.conf.ctmpl:/root/consul/playbook/nginx/local/nginx-local.conf:/bin/bash -x /root/consul/playbook/nginx/local/out.sh /root/consul/playbook/nginx/local"

# 2. vi web.json about service info, one info one time

# 3. push services info to services
curl -X PUT --data-binary @web.json http://localhost:8500/v1/agent/service/register

# 4. it will auto change config  
