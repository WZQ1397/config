##保留每月的月初和月末的文件和目录，删除其他
#!/bin/bash
BASEDIR='/home/lph/shell/'
FILENAME="$(ls $BASEDIR)"
for myfile in $FILENAME
  do
    FILEDATE=`find $BASEDIR -name $myfile -printf "%TY%Tm%Td"`
    MONTH="${FILEDATE:4:2}"
    YEAR="${FILEDATE:0:4}"
    LASTDAY=`cal $MONTH $YEAR | xargs | awk '{print $NF}'`
    LASTDATE=$YEAR$MONTH$LASTDAY
    FIRSTDATE="$YEAR$MONTH"01
    if [ $FILEDATE -eq $FIRSTDATE -o $FILEDATE -eq $LASTDATE ]; then
        echo $BASEDIR$myfile
    else
        rm -rf $BASEDIR$myfile 
    fi
done
