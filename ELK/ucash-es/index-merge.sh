> run.sh
for x in `seq 4 8`; do bash reindex.sh ucash-online 2021.0$x >> run.sh; echo "sleep 60" >> run.sh ; done
bash run.sh

