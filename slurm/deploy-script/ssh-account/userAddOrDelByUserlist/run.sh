#item=(yuhangzhou chaofanma hyguan yxhuang bsguo xiaomanzhang zdcheng admin yazhang yanghengzhao yhu jxliu slren dulianyu lefeizhang huili zhiyuanzhu)
item=(tjzhang)
function adduser(){
  username=`echo $1 | awk -F ":" '{print $1}'`
  uid=`echo $content | awk -F ":" '{print $3}'`
  gid=`echo $content |awk -F ":" '{print $4}'`
  home=`echo $content |awk -F ":" '{print $6}'`
  shell=`echo $content |awk -F ":" '{print $7}'`
  groupadd $username -g $gid
  useradd $username -u $uid -g $gid -s $shell -d /DB/rhome/$username
}

function deluser(){
  username=`echo $1 | awk -F ":" '{print $1}'`
  uid=`echo $content | awk -F ":" '{print $3}'`
  gid=`echo $content |awk -F ":" '{print $4}'`
  home=`echo $content |awk -F ":" '{print $6}'`
  shell=`echo $content |awk -F ":" '{print $7}'`
  userdel $username
  groupdel $username
}

for x in ${item[@]};
do
  content=`grep ^$x: passwd`;
  echo `grep ^$x: shadow` >> /etc/shadow
  echo $content
  #continue
  adduser $content
  #deluser $content
done
