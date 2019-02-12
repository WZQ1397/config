### SQL优化：
+ 1、使用deadline/noop这两种I/O调度器，千万别用cfq（它不适合跑DB类服务）；
+ 2、使用xfs文件系统，千万别用ext3；ext4勉强可用，但业务量很大的话，则一定要用xfs；
+ 3、文件系统mount参数中增加：noatime, nodiratime, nobarrier几个选项（nobarrier是xfs文件系统特有的）；
+ 4、将vm.swappiness设置为5-10左右即可，甚至设置为0（RHEL 7以上则慎重设置为0，除非你允许OOM kill发生），以降低使用SWAP的机会；
+ 5、将vm.dirty_background_ratio设置为5-10，将vm.dirty_ratio设置为它的两倍左右，以确保能持续将脏数据刷新到磁盘，避免瞬间I/O写，产生严重等待（和MySQL中的innodb_max_dirty_pages_pct类似）；
+ 6、将net.ipv4.tcp_tw_recycle、net.ipv4.tcp_tw_reuse都设置为1，减少TIME_WAIT，提高TCP效率；

### 参数方面：
+ 1、选择Percona或MariaDB版本的话，强烈建议启用thread pool特性，可使得在高并发的情况下，性能不会发生大幅下降。
+ 2、设置default-storage-engine=InnoDB，也就是默认采用InnoDB引擎，强烈建议不要再使用MyISAM引擎了，InnoDB引擎绝对可以满足99%以上的业务场景；
+ 3、调整innodb_buffer_pool_size大小，如果是单实例且绝大多数是InnoDB引擎表的话，可考虑设置为物理内存的50% ~ 70%左右；
+ 4、根据实际需要设置innodb_flush_log_at_trx_commit、sync_binlog的值。如果要求数据不能丢失，那么两个都设为1。如果允许丢失一点数据，则可分别设为2和10。而如果完全不用care数据是否丢失的话（例如在slave上，反正大不了重做一次），则可都设为0。这三种设置值导致数据库的性能受到影响程度分别是：高、中、低，也就是第一个会另数据库最慢，最后一个则相反；
+ 5、设置innodb_file_per_table = 1，使用独立表空间，我实在是想不出来用共享表空间有什么好处了；
+ 6、设置innodb_data_file_path = ibdata1:1G:autoextend，千万不要用默认的10M，否则在有高并发事务时，会受到不小的影响；
+ 7、设置innodb_log_file_size=256M，设置innodb_log_files_in_group=2，基本可满足90%以上的场景；
+ 8、设置long_query_time = 1，而在5.5版本以上，已经可以设置为小于1了，建议设置为0.05（50毫秒），记录那些执行较慢的SQL，用于后续的分析排查；
+ 9、根据业务实际需要，适当调整max_connection（最大连接数）、max_connection_error（最大错误数，建议设置为10万以上，而open_files_limit、innodb_open_files、table_open_cache、table_definition_cache这几个参数则可设为约10倍于max_connection的大小；
+ 10、常见的误区是把tmp_table_size和max_heap_table_size设置的比较大，曾经见过设置为1G的，这2个选项是每个连接会话都会分配的，因此不要设置过大，否则容易导致OOM发生；其他的一些连接会话级选项例如：sort_buffer_size、join_buffer_size、read_buffer_size、read_rnd_buffer_size等，也需要注意不能设置过大；
+ 11、由于已经建议不再使用MyISAM引擎了，因此可以把key_buffer_size设置为32M左右，并且强烈建议关闭query cache功能；