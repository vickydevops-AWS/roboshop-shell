source common.sh
component=Redis


PRINT Disable Redis defauly
dnf module disable redis -y &>>$LOG_FILE
STAT $?

PRINT Enable Redis 7
dnf module enable redis:7 -y &>>$LOG_FILE
STAT $?

PRINT Install Redis 7
dnf install redis -y &>>$LOG_FILE
STAT $?

PRINT Update Redis config
sed -i -e '/^bind/ s/127.0.0.1/0.0.0.0/'  -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
STAT $?

PRINT Start Redis service
systemctl enable redis &>>$LOG_FILE
systemctl restart redis &>>$LOG_FILE
STAT $?
