#!/bin/bash
# Author: Zach.Wang

now=`date +%Y-M%m`
last=`date -d "1 month ago" +%Y-M%m`
github_url="https://api.github.com"
organization="Zach"
repo="zach.puppet"
user=`whoami`
token="${GITHUB_TOKEN}"
header="Accept: application/vnd.github.v3+json"
dev="development"

function init_repo(){
    git config --global user.name "${user}"
    git config --global user.email "${user}@zach.com"
    git remote add ${user}-pup https://github.com/${organization}/${repo}.git
}

function github_pr(){
    # pull request
    version=${now}

    env=$1

    if [[ ${env} == ${dev} ]];
    then
       branch=${user}-${version}
    else
       branch=${dev}
       echo "You select ${env}, PLEASE INPUT CR-TICKET"
       read TIKECT_NO
    fi
    
    
    TitleTemplate="${version} patch to ${env} machines"
    ContentTemplate="Please kindly review ${env} and apply merge ${TIKECT_NO}"

    curl --location --request POST \
    -H ${header} --header "Authorization: Bearer ${token}" \
    ${github_url}/repos/${organization}/${repo}/pulls \
    -d '{
        "base":"'${env}'",
        "head":"'"${branch}"'",
        "title":"'"${TitleTemplate}"'",
        "body":"'"${ContentTemplate}"'"
    }'

}

function github_get_latest_pr_info(){
    curl -s -H 'Accept: application/vnd.github.v3.text-match+json' --header "Authorization: Bearer ${token}" \
    ${github_url}/search/issues?q=user:${user}-sh+repo:${organization}/${repo}+is:pr+state:open&sort=created&order=asc 
}

function github_mr(){
    # merge request
    version=${now}
    env=$1
    pr_seq=$2
    if [[ $env == ${dev} ]];
    then

        curl --location --request PUT \
        -H "${header}" --header "Authorization: Bearer ${token}" \
        ${github_url}/repos/${organization}/${repo}/pulls/${pr_seq}/merge \
        -d '{
            "commit_title":"'"${user}-${version}"'"
        }'
    else
        echo "Open: https://github.com/zach/zach.puppet/pull/${pr_seq}"
    fi
    exit 0
}

function patching_update(){

    echo $now $last
    repo="zach.puppet"
    pushd ${repo} 
    git checkout -b ${user}-${now}
    filelist=`grep -R ${last} * | awk -F ':' '{print $1}' | uniq`
    echo $filelist
    sed -i "s#${last}#${now}#g" $filelist
    git status
    git add --all .
    git commit -a -m ${user}-${now}
    git push --set-upstream origin ${user}-${now}
}

select env in development production
do
    patching_update
    github_pr ${env}
    sleep 5
    github_get_latest_pr_info
    pr_seq=`github_get_latest_pr_info | jq .items[].number`
    echo "Update PR-${pr_seq}"

    github_mr ${env} ${pr_seq}

done

# git merge development -m 'zhwang-2022-M03'