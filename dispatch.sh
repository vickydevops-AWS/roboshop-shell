Souce common.sh
component=dispatch
app_path=/app
SYSTEMD_SETUP

PRINT Install golang client
dnf install golang -y &>>$LOG_FILE
STAT $?

APP_PRERO

print dispatch service
go mod init dispatch &>>$LOG_FILE
go get &>>$LOG_FILE
go build &>>$LOG_FILE
STAT $?