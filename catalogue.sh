source common.sh
component=catalogue
App_Path=/app
NODEJS

echo Install MongoDB Client
dnf install mongodb-mongosh -y &>>$LOG_FILE
STAT $?

echo Load Master Data
mongosh --host mongoDB.dev.vickydevops.online </app/db/master-data.js &>>$LOG_FILE
STAT $?
