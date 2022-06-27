#!/bin/bash
# Update by Zach.Wang

GCLOUD_ACCOUNT="${USER}@stubmain.cloud"
SNAPSHOT_ROLE_LIST="/nas/utl/NOC/patching/rebootable_roles.txt"

function is_login(){
    login_info=`gcloud auth list --filter=status:ACTIVE --filter-account="${GCLOUD_ACCOUNT}" --format="value(account)" | wc -l` 
    [[ $login_status ]] && echo "Need to login" || echo "Has login"
    return $login_info
}

function set_login_profile(){
    login_status=$((is_login))

    if [[ $login_status ]]; then
        echo "Set gcloud account to ${GCLOUD_ACCOUNT}."
        gcloud config set core/account ${GCLOUD_ACCOUNT}
    else
        echo "No active gcloud account, please login."
        gcloud auth login
    fi
}

function set_project_profile(){
    echo "Please enter project name (uswp01 or uswp02)"
    read PROJECT_NAME
    projectId=`gcloud projects list --format="value(projectId)" --filter="name='${PROJECT_NAME}'"`
    # Whether can get specfic project id
    if [ -z "${projectId}" ]; then
        echo "project ${PROJECT_NAME} not found"
        exit 1
    else 
        gcloud config set project ${projectId}
    fi
}

function run_snapshot_process(){
    readarray -t roles < ${SNAPSHOT_ROLE_LIST}
    datetime=`date +%Y-%m`
    logpath=auto-patching/inventories/prd/gcp-snapshot-logs/${datetime}
    mkdir -pv ${logpath}
    for role in ${roles[@]}
    do
        {
            # echo ${role}
            disk_list="${logpath}/disks.tmp.${role}"
            gcloud compute disks list | grep "${PROJECT_NAME}${role}" | awk '{print $1,$2}' | tee ${disk_list}
            while read -r line
            do
                disk=$(echo "$line" | awk '{print $1}')
                zone=$(echo "$line" | awk '{print $2}')q
                snapshot_name=$disk"-snapshot$(date '+%Y%m%d')"
                # echo ${snapshot_name}
                gcloud compute disks snapshot "$disk" --zone="$zone" --snapshot-names="$snapshot_name" | tee -a ${logpath}/gcp-snapshot-${role}.log
            done < ${disk_list}
        }&
        # CLEAN EXAMPLE
        # gcloud compute snapshots list --filter="creationTimestamp<='2022-01-01' AND creationTimestamp>='2020-01-09'" --format=json | jq .[].name | xargs gcloud compute snapshots delete
		# gcloud compute snapshots list --filter="creationTimestamp<='2022-06-15' AND creationTimestamp>='2022-06-01'"  --format="table(name,creationTimestamp,status)"
    done
    ps aux | grep gcloud | grep uswp01 | awk '{print $2}' > ${logpath}/pid.cur
}

function start_handler(){
    set_login_profile
    set_project_profile
    run_snapshot_process
}

# start point
start_handler