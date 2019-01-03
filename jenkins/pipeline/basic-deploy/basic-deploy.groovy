node {
   def MVN_HOME
   def EXEC_DIR
   def JENKINS_ADDRESS
   stage('getcode') {
      git branch: '$branch', credentialsId: 'cbcf6d01-eacf-4d52-9132-96685e423d4d', url: 'ssh://jenkins@54.223.183.130:29418/wx/wx-parent.git'
   }
  stage('Build') {
      MVN_HOME = tool 'mvn'
      def WORKSPACE = "/var/lib/jenkins/workspace"
      sh "cd $WORKSPACE/$JOB_NAME && $MVN_HOME/bin/mvn  -U -e clean install -Dmaven.test.skip=true -P sit"
  } 
   stage('code-check') {
      sh "echo $JOB_NAME-$subject-$tag in $branch"
   }
   stage('deploy') {
       JENKINS_ADDRESS="172.16.49.97:8080"
       def TARGET_NAME= $JOB_NAME-$subject
       withCredentials([file(credentialsId: 'dde9d890-6900-4d7a-b63d-b6cf40716911', variable: 'deploy-server-login')]) {
        sh "ssh web@$SERVER /data/deploy/bin/deploy-$TARGET_NAME-10081-$tag.sh http://$JENKINS_ADDRESS/job/$JOB_NAME/$BUILD_NUMBER/execution/node/3/ws/$TARGET_NAME/target/$TARGET_NAME-1.0-SNAPSHOT.jar"
       }
   }
}