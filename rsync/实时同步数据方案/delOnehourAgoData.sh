#!/bin/bash
function singleton()
{
  name=`basename $0`
  pidpath=/tmp/$name.pid
  if [[ -f "$pidpath" ]];
  then
    kill `cat $pidpath`  
    rm -vf $pidpath
  fi
  # only for single process
  #  echo $$ >$pidpath  
  ps aux | grep -v grep | grep $name | awk '{printf $2" "}' > $pidpath
}

singleton

# global var
target_root=$1
save_min=$2
target_root=${target_root:-"/data2/save-data/camera/movePicFromMemDisk/camera"}
save_min=${save_min:-1}
if [[ $target_root == "" ]] || [[ $1 == "" ]];
then
   echo "Usage: $0 $target_root $save_min" 
fi
if [[ ! -d $target_root ]];
then
   mkdir -pv $target_root
fi
while true;
do
  for cam in `seq 1 9`;
  do
    find $target_root/$cam/ -cmin +$save_min -type f -print -delete
  done
  sleep 30
  date
done
