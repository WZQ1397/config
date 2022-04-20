keyword=$1
token="""Authorization: Token token=$token"""

curl -s --request GET \
  --url https://api.pagerduty.com/teams?query=${keyword} \
  --header 'Accept: application/vnd.pagerduty+json;version=2' \
  --header "${token}" \
  --header 'Content-Type: application/json' | jq . | grep -E '"id":|"name":'