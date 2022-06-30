for projectname in usee01 usee02 uswp01 uswp02;
do
    projectid=`gcloud projects list --format="value(projectId)" --filter="name=${projectname}"`
    echo ${projectid}
    gcloud compute snapshots list --project="${projectid}" --filter="creationTimestamp<='2022-01-01' AND creationTimestamp>='2020-01-01'" --format=json | jq .[].name #| xargs gcloud compute snapshots delete
done

