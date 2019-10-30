node {
  def remote = [:]
  remote.name = 'deploy'
  remote.host = '172.17.xxxx'
  remote.user = 'web'
  remote.password = 'tsjinrong'
  remote.allowAnyHosts = true
  def jk = [:]
  jk.name = 'jk'
  jk.host = '172.16.xxxxx'
  jk.user = 'root'
  jk.password = 'TSjinrong'
  jk.allowAnyHosts = true
  stage('Preparation') { // for display purposes
    if(use_branch=="yes")
    { 
        echo "$use_branch"
        git branch: '$BRANCH', url: '$repo'
       
    }
    else{
      git '$repo'
      
    }
  }
  stage('Build') {
    sshCommand remote: jk, command: "bash /data/jenkins-stat.sh $JOB_NAME $BUILD_NUMBER $STAGE 0 "
  }
  
  stage('skip GFW to deploy'){
    sshCommand remote: remote, command: "curl -XGET 'http://47.xxxxxx:5000/?project=$JOB_NAME&port=$SVC_PORT&ex_port=$EX_PORT&jarname=$JAR_NAME&buildnum=$BUILD_NUMBER'"
  }
  stage('run status') {
    sshCommand remote: remote, command:"kubectl get deployment tsjr-$JOB_NAME-$SVC_PORT"
  }
   stage('success notice') {
     sshCommand remote: jk, command: "bash /data/jenkins-stat.sh $JOB_NAME $BUILD_NUMBER $STAGE 1 "
   }
}