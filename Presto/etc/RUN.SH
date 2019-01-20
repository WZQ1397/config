#!/bin/bash
CMD="{{ Presto_PATH }}/bin/launcher restart" &
ssh hadoopmaster1 CMD 
ssh hadoopmaster2 CMD 
for x in $(seq 1 15)
do
ssh hadoopslave$x CMD
done