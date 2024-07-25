source common.sh
component=MongoDB

PRINT Copy MongoDB repo file
cp Mongo.repo /etc/yum.repos.d/mongo.repo
STAT $?

PRINT Install MongoDB
dnf install mongodb-org -y
STAT $?

PRINT Update MongoDB repo file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STAT $?

PRINT Start MongoDB service
systemctl enable mongod
systemctl restart mongod
STAT $?
