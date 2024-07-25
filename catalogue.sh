source common.sh
component=catalogue
app_path=/app
schema_setup=MongoDB
NODEJS

echo Install MongoDB Client
dnf install mongodb-mongosh -y &>>$LOG_FILE
STAT $?

echo Load Master Data
mongosh --host mongoDB.dev.vickydevops.online </app/db/master-data.js &>>$LOG_FILE
STAT $?
