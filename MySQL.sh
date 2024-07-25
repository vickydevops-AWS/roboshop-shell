source common.sh
component=MongoDB

PRINT Install MySQL server
dnf install mysql-server -y &>>$LOG_FILE
STAT $?

PRINT Start MySQL server
systemctl enable mysql &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
STAT $?

PRINT Setup MySQL Root Password
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
STAT $?
