# Author Zach.Wang
import urllib2
import json
import time
import requests

#consul config
host='172.16.48.104'
Url='http://' + host + ':8500/v1/health/state/any'

dingdingalert='https://oapi.dingtalk.com/robot/send?access_token=ee6d5276788ac9afdf5480e3e731334ba7cefc39f4255dc623f8041493d9c543'

#consul api
req = urllib2.Request(Url)
resp = urllib2.urlopen(req)

data={}
for server in json.loads(resp.read()):
    if server['Name'] == 'Serf Health Status' and server['Status'] == 'passing':
        data['title']= "Consul Node " + server['Node'] + " Status seems Not Good\n\n"
        data['text']= "### " + data['title'] + " @18916295546 \n\n" + \
		"#### " + server['Name'].replace('Service \'','').replace('\' check','') + ": " + server['Status'] +\
		"\n\n\n > "+ server['Output'] + "\n\n" + \
		"[MoreInfo](http://" + host + ":8500/v1/agent/metrics)"
        #data['messageUrl']= "http://" + host + ":8500/v1/agent/metrics"

if server['Status'] != 'passing':
    headers = {'Content-Type': 'application/json'}
    send_data = {"msgtype": "markdown", "markdown": data, "at": {"atMobiles": ["18916295546"],"isAtAll": "false"}}
    print json.dumps(send_data)
    requests.post(dingdingalert,data=json.dumps(send_data),headers=headers)
