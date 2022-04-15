token="""Authorization: Token token=$token"""

filename=$1
groupid=$2
role=$3
# observer responder manager
role=${role:-observer}

for username in `cat ${filename}`; 
do 
  curl --request PUT \
    --url https://api.pagerduty.com/teams/${groupid}/users/${username} \
    --header 'Accept: application/vnd.pagerduty+json;version=2' \
    --header "${token}" \
    --header 'Content-Type: application/json' \
    --data '{
    "role": "'${role}'"
  }'
done