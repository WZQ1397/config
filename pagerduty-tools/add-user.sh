
mail_address=$1
job=$2
if [[ ${mail_address} == "" ]] || [[ ${job} == "" ]];
then
  exit -1
fi

username=`echo ${mail_address} | awk -F '@' '{print $1}'`

curl --request POST \
  --url https://api.pagerduty.com/users \
  --header 'Accept: application/vnd.pagerduty+json;version=2' \
  --header 'Authorization: Token token=$token' \
  --header 'Content-Type: application/json' \
  --header "From: ${mail_address}" \
  --data '{
  "user": {
    "type": "user",
    "name": "'${username}'",
    "email": "'${mail_address}'",
    "time_zone": "America/Los_Angeles",
    "color": "green",
    "role": "observer",
    "job_title": "'"""${job}"""'",
    "avatar_url": "https://secure.gravatar.com/avatar/1d1a39d4635208d5664082a6c654a73f.png?d=mm&r=PG",
    "description": ""
  }
}'
