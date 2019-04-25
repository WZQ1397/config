#!/bin/bash
for x in `/root/consul kv export | grep key | awk -F "\"" '{print $4}' | grep -v local`
do
./consul kv delete $x
done
