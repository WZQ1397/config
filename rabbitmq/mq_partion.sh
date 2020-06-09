export ERLANG_HOME=/data/rabbitmq/erlang
export PATH=$ERLANG_HOME/bin:$PATH
cd /data/rabbitmq/rabbitmq_server-3.5.6/
./sbin/rabbitmqctl cluster_status
./sbin/rabbitmqctl stop_app
sleep 5
./sbin/rabbitmqctl start_app
./sbin/rabbitmqctl cluster_status
