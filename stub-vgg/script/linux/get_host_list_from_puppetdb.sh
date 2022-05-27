#!/bin/bash
# Author: Zach.Wang
# DESC: get host list from puppetdb

function get_host_list(){
    CONDITION=$1
    CONDITION=${CONDITION:-*}
    PUPPETDB_DOAMIN=`awk '/puppetdb/{print $NF}' /etc/hosts`
    URL="http://$PUPPETDB_DOAMIN:8080/v3/nodes"
    orifilename=ori-`date +%Y-%m-%d `.list
    matchhostlist=filter-$CONDITION-`date +%Y-%m-%d`.log
    content=`curl --silent -GX GET $URL | jq .[].name | tee $orifilename`
    grep $CONDITION $orifilename | sed 's/"//g' | tee $matchhostlist
    echo "Match $CONDITION hosts:" `wc -l $matchhostlist | awk '{print $1}'`
}


# get_host_list $1
