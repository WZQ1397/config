#!/bin/bash

for i in $(mongo --quiet --host 192.168.10.70 --eval "db.getMongo().getDBNames()" | tr "," " ");
do
  mongo $i --host 192.168.10.14  --eval "db.dropDatabase()";
done
