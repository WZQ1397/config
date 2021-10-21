use mysql;
delete from user where user = ' ' and host = 'localhost' ;
delete from user where user = ' ' and host = 'node11';
grant all privileges on *.* to 'root'@'localhost' identified by 'slurm';
grant all privileges on *.* to 'root'@'127.0.0.1' identified by 'slurm';
grant all privileges on *.* to 'root'@'%' identified by 'slurm';
create database slurm_acct_db;
grant all privileges on slurm_acct_db.* to 'slurm'@'%' identified by 'slurm_acct123!';
flush privileges;