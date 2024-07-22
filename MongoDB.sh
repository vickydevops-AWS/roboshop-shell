cp Mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y
##update conf file
systemctl enable mongod
systemctl restart mongod
