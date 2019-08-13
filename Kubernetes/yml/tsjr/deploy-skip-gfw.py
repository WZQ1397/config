from flask import Flask,request
import string,re,os
app = Flask(__name__)

@app.route('/')
def suncash():
    deploy_path='/tsjr-data/deploy-java/generator/deploy/'
    sunny={'proj':'','port':'','jarname':'','ex_port':'','stage':''}
    buildnum=request.args.get('buildnum', '')
    sunny['proj'] = request.args.get('project','')
    sunny['port'] = request.args.get('port', '')
    sunny['jarname'] = request.args.get('jarname','')
    sunny['ex_port'] = request.args.get('ex_port', '')
    sunny['ex_port'] = request.args.get('ex_port', '')
    sunny['stage']=sunny['proj'].split("-")[-1]
    command='bash -xe ' + deploy_path + 'deploy-k8s.sh '+ sunny['proj']+" "+sunny['port']+" "+sunny['stage'] \
            + " " + sunny['jarname'] +" "+sunny['ex_port']+" "  + buildnum + " " + '>> ' + deploy_path + 'GFWdeploy.history'
    os.popen(command)
    return sunny.get('proj')

if __name__ == '__main__':
    #app.run('0.0.0.0',debug=True)
    app.run('0.0.0.0')
