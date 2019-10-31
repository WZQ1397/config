node {
  def remote = [:]
  remote.name = 'deploy'
  remote.host = '172.16.xxxxxx'
  remote.user = 'root'
  remote.password = 'TSjinrong'
  remote.allowAnyHosts = true
  stage('ready to push') {
     sshCommand remote: remote, command: "/data/jenkins-tools/deploy-app-front.sh $SVC_NAME $JOB_NAME"
  }
  stage(' ready to deploy'){
    SERVER = '47.74.xxxxxx'
    sh "ssh -i $JENKINS_HOME/aliyunweb web@$SERVER /tsjr-data/nginx-data/web/deploy-app-front.sh $SVC_NAME $JOB_NAME $BUILD_NUMBER"
  }
}