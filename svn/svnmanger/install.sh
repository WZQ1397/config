
yum install -y subversion httpd

mkdir -pv /webser/svn/{repos,svn,svnconfig}
touch /webser/svn/repos{passwdfile,accessfile}
chown apache.apache /webser/svn -R

http://sourceforge.net/projects/svnmanager/
pear install --alldeps VersionControl_SVN-0.3.3

mysql -uroot -p

create database svnmanger;
grant all on svnmanger.* to svnmanger@localhost identified by 'svnmanger';
flush privileges;

#默认用户和密码都为admin，创建新用户后，admin用户失效
