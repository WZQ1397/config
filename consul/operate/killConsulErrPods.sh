pods=$(kubectl get pods -o wide | grep prd | grep -v 140 | grep -v 152 | awk '{print $1"@@"$(NF-2)}')
curl http://172.30.197.185:8500/v1/agent/checks | jq .[].Output | grep -v '{\\"status\\":\\"UP\\"}' | awk -F "://" '{print $2}' | awk -F ":8080" '{print $1}' > errlist
for pod in `echo $pods`;
do
for v in `cat errlist`;
do
   res=`echo $pod  | grep $v | cut -d "@" -f 1`
   if [[ $res != "" ]];
   then
      echo $res
      #kubectl delete pod $res
   fi
done
done
#rm -rf errlist
