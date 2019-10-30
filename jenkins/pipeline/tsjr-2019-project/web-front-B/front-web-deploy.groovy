
node {
  def remote = [:]
  remote.name = 'deploy'
  remote.host = '172.16.xxxx'
  remote.user = 'root'
  remote.password = 'TSjinrong'
  remote.allowAnyHosts = true
  stage('ready to push') {
    DEP_PATH = '/data2/jenkins-data/workspace'
    echo "$STAGE"
    if (STAGE=="sit"){
       git branch: 'master', url: '$repo'
    }
    else
    {
       git branch: '$STAGE', url: '$repo'
    }
    sshCommand remote: remote, command: "rm -rf $DEP_PATH/$JOB_NAME/$FILE_NAME; tar zcvf $DEP_PATH/$JOB_NAME/$FILE_NAME $DEP_PATH/$JOB_NAME/dist"
  }
  stage(' ready to deploy'){
    SERVER = '47.74.xxxxx'
    sh "ssh -i $JENKINS_HOME/aliyunweb web@$SERVER /tsjr-data/nginx-data/web/deploy-web.sh $SVC_NAME $BUILD_NUMBER $FILE_NAME sit $JOB_NAME"
  }
}