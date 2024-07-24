source common.sh
component=catalogue
NODEJS

dnf install mongodb-mongosh -y
mongosh --host mongoDB.dev.vickydevops.online </app/db/master-data.js
