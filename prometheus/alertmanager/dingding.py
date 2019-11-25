from flask import Flask
from flask import request
import json
import requests

app = Flask(__name__)

def transform(text):
    textMap = json.loads(text)
    print(json.dumps(textMap, sort_keys=True, indent=4, separators=(',', ': ')))
    nodePorturl = 'http://172.16.48.1:9090/'
    externalURL = textMap['externalURL']
    print(externalURL)
    links =[]
    for alert in textMap['alerts']:
        print('-------------')
        time = alert['startsAt'] + ' -- ' + alert['endsAt']
        generatorURL = alert['generatorURL'];
        generatorURL = nodePorturl+generatorURL[generatorURL.index('graph'):]
        summary = alert['annotations']['summary']
        #description = alert['annotations']['description']
        status = alert['status']
        title = alert['labels']['alertname'] + " " + alert['labels']['alertname']
        link = {}
        link['title'] = title
        link['text'] = status + ': ' + summary
        link['messageUrl'] = generatorURL
        link['picUrl'] = ''
        links.append(link)
    return links

@app.route('/',methods=['POST'])
def send():
    print('ok')
    if request.method == 'POST':
        post_data = request.get_data()
        alert_data(post_data)
    return "hello"

def alert_data(data):
    url = 'https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxx'
    headers = {'Content-Type': 'application/json'}
    for link in transform(data):
        send_data = {"msgtype": "link", "link": link}
        print(send_data)
        r = requests.post(url, data=json.dumps(send_data), headers=headers)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
