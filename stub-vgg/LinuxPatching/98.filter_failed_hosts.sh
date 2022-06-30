awk '{printf $2}' $1 | sed 's/\[//g' | sed 's#]:#,#g'
