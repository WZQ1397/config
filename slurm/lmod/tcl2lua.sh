# Filename: translate.sh
# Created by: Namratha Urs
# Date of Creation: June 13, 2019

# Description:  Translates a Tcl file to Lua
# Inputs:       Assumes input from the parent script that invokes this script
# Outputs:      Generates Lua code

#!/bin/bash

# location of tcl2lua.sh - /cm/shared/utils/LMOD/7.8/lmod/lmod/libexec
# LMOD_DIR environment variable contains the location of the tcl2lua.sh script that will be used for the translation effort
if [ -z $LMOD_DIR ] # check if the environment variable exists
then
        # if the environment variable is unset
        lmod_dir="/cm/shared/utils/LMOD/7.8/lmod/lmod/libexec"
else
        # if the environment variable is set
        lmod_dir=$LMOD_DIR
fi

to_lua_script="tcl2lua.tcl"

if [ ! -d $2 ]
then
        mkdir -p $2
fi

# indexed array 'Dirs' is created
declare -a DIRS
#DIRS=( foo bar )

#echo $1
full_path=$(readlink -f $1)
#echo $full_path
#echo $2
target_dir=$2
#echo $3
root_dir=$(basename $3)
#echo $root_dir

file=$(basename $full_path)
temp=$(dirname $full_path)
#echo $file
#echo $temp
DIRS=( $file "${DIRS[@]}" )

while [ $(basename $temp) != $root_dir ]
do
        file=$(basename $temp)
        temp=$(dirname $temp)
        #echo ""
        #echo $file
        #echo $temp
        DIRS=( $file "${DIRS[@]}" )
        #echo $file, $temp
done

#echo ${DIRS[*]}

if [ ! -d $target_dir ]
then
        mkdir -p $target_dir
fi

path=$target_dir
counter=0
for val in "${DIRS[@]}"
do
        arr_length=${#DIRS[@]}
        #echo $arr_length
        comp=$(( $arr_length - 1 ))
        #echo $comp
        if [ $counter -lt $comp ]
        then
                path=$path/$val
                counter=$(( $counter + 1 ))
        else
                #echo $path
                #echo ""
                mkdir -p $path  
        tclsh $lmod_dir/$to_lua_script $full_path > $path/$val.lua
        fi
done

