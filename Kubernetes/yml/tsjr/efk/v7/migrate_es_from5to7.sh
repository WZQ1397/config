docker run --rm -i taskrabbit/elasticsearch-dump --input=http://10.0.114.78:9200/logstash-2019.04-full-01  --output=http://10.0.78.206:9200/logstash-2019.04-full --limit=10000 --all=true
