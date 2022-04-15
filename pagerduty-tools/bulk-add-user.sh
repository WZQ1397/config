filename=$1
for mail in `cat ${filename}`; 
do 
  bash add-user.sh $mail "Data Engineer" | tee -a result.`date +%Y%m%d`;
done