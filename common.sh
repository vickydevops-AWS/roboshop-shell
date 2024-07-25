LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

PRINT(){
  echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  echo "##################################### $* ####################################" &>>$LOG_FILE
  echo $*
}

STAT() {
    if [ $1 -eq 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      echo "Refer the log file for the more information : File path : ${LOG_FILE}"
      exit $1
    fi
}

NODEJS() {
  echo disable nodeJS Default Version
  dnf module disable nodejs -y &>>$LOG_FILE
  STAT $?


  echo Enable nodeJS 20 Module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  STAT $?

  echo install Nodejs
  dnf install nodejs -y &>>$LOG_FILE
  STAT $?

  echo copy service file
  cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  STAT $?

  echo COpy MongoDB repo file
  cp Mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
  STAT $?

  echo Adding Application user
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
   useradd roboshop &>>$LOG_FILE
  fi
  STAT $?

  echo Cleaning old content
  rm -rf /app &>>$LOG_FILE
  STAT $?

  echo Create app directory
  mkdir /app &>>$LOG_FILE
  STAT $?

  echo Download app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE
  STAT $?

  cd /app

  echo Extract App content
  unzip /tmp/${component}.zip &>>$LOG_FILE
  STAT $?

  echo download NodeJS Dependencies
  npm install &>>$LOG_FILE
 STAT $?

  echo start servive
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  STAT $?
}