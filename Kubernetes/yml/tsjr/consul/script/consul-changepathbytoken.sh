export CONSUL_HTTP_TOKEN="pf2e&^T#\$vddf0q"
for x in `consul kv export | grep key | awk -F "\"" '{print $4}' | grep prd`
do
consul kv get $x | consul kv put `echo $x | sed 's#prd#online#g'` -
done
