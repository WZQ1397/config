#!/bin/bash
PATH=$1
TAG=`echo $1 |/usr/bin/awk -F "/" '{print $NF}'`
TARGET='/data'
NAME=`echo $1 |/usr/bin/awk -F "/" '{print $(NF-1)}'`
/usr/bin/grep -E '[[:alnum:]]$|[[:punct:]]$' $PATH/$NAME.conf > $TARGET/$NAME.conf
echo "$NAME-$TAG ok"
