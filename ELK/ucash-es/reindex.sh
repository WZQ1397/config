list=""
indexname=$1
timerange=$2
for x in `curl -s  'localhost:9200/_cat/indices' | grep "$indexname-$timerange" | awk '{print $3}'`; 
do
   list=$list\"$x\"","
done
echo " 
curl -X POST 'http://127.0.0.1:9200/_reindex?wait_for_completion=false' -H 'Content-Type: application/json' -d'
{
\"source\": {
\"index\": [${list::-1}]
},
\"dest\": {
\"index\": \"$indexname-$timerange-full\"
}
}'
"

