#!/bin/bash
svc_name=$1
job_name=$2
jk_path=/data2/jenkins-data/workspace

cd $jk_path
if [ ! -f $job_name/.git/info/sparse-checkout ];
then
  pwd
  if [ -d $job_name ];
  then
    INT=1
    cd $job_name && git init
  else
    INT=1
    mkdir $job_name && cd $job_name && git init
  fi
  git config core.sparsecheckout true
  echo 'loanRecords/dist*' >> .git/info/sparse-checkout
  echo 'aboutUs*' >> .git/info/sparse-checkout
  echo 'protocol*' >> .git/info/sparse-checkout
  git remote add origin http://172.16.xxxxx:3000/suncash/$svc_name.git
fi
[[ $INT ]] && pwd || cd $job_name
rm -rf app-front.tar.gz	
git pull origin master
cd ..
tar zcvf $jk_path/$svc_name.tar.gz $job_name
mv $svc_name.tar.gz $job_name
