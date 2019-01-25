list=$1
cat $list | while read line
do
    ./consul kv put prometheus/auto/`echo $line | awk -F ":" '{print $1}'` `echo $line | awk -F ":" '{print $NF}'`
done
