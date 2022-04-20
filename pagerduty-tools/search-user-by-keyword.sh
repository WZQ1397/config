token="""Authorization: Token token=$token"""

username=$1
curl -s --request GET \
  --url https://api.pagerduty.com/users?query=${username} \
  --header 'Accept: application/vnd.pagerduty+json;version=2' \
  --header "${token}" \
  --header 'Content-Type: application/json' | jq .users[].id 
