LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

PRINT(){
  echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  echo "######################## $* ####################"
  echo $*
}

NODEJS() {
  echo disable nodeJS Default Version
  dnf module disable nodejs -y &>>$LOG_FILE

  echo Enable nodeJS 20 Module
  dnf module enable nodejs:20 -y &>>$LOG_FILE

  echo install Nodejs
  dnf install nodejs -y &>>$LOG_FILE

  echo copy service file
  cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE

  echo COpy MongoDB repo file
  cp Mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

echo Adding Application user
  useradd roboshop &>>$LOG_FILE

  echo Cleaning old content
  rm -rf /app &>>$LOG_FILE

  echo Create app directory
  mkdir /app &>>$LOG_FILE

  echo Download app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE

  cd /app

echo Extract App content
  unzip /tmp/${component}.zip &>>$LOG_FILE

echo download NodeJS Dependencies
  npm install &>>$LOG_FILE

echo start servive
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
}