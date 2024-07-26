LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
code_dir=(pwd)

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

APP_PREREQ() {
  PRINT Adding Application user
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ]; then
    useradd roboshop &>>$LOG_FILE
  fi
  STAT $?

  PRINT remove old content
  rm -rf ${app_path}  &>>$LOG_FILE
  STAT $?

  PRINT Create App Directory
  mkdir  ${app_path}  &>>$LOG_FILE
  STAT $?

  PRINT Download Application content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>>$LOG_FILE
  STAT $?

  PRINT Extract Application content
  cd ${app_path}
  unzip /tmp/${component}.zip  &>>$LOG_FILE
  STAT $?
}

SYSTEMD_SETUP(){
  PRINT copy service file
    cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
    STAT $?

    PRINT start service
      systemctl daemon-reload &>>$LOG_FILE
      systemctl enable ${component} &>>$LOG_FILE
      systemctl restart ${component} &>>$LOG_FILE
      STAT $?
}

NODEJS() {
  PRINT disable nodeJS Default Version
  dnf module disable nodejs -y &>>$LOG_FILE
  STAT $?


  PRINT Enable nodeJS 20 Module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  STAT $?

  PRINT install Nodejs
  dnf install nodejs -y &>>$LOG_FILE
  STAT $?

  PRINT COpy MongoDB repo file
  cp Mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
  STAT $?


APP_PREREQ

  PRINT download NodeJS Dependencies
  npm install &>>$LOG_FILE
  STAT $?

  SCHEMA_SETUP
  SYSTEMD_SETUP

}

JAVA(){

 PRINT Install Maven and Java
 dnf install maven -y
 STAT $?

APP_PREREQ

 PRINT Download Dependencies
 mvn clean package
 mv target/shipping-1.0.jar shipping.jar
 STAT $?

 SCHEMA_SETUP
 SYSTEMD_SETUP

}

SCHEMA_SETUP(){
 if [ "$schema_setup" == "MongoDB" ]; then
  PRINT Copy MongoDB repo file
  cp Mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
  STAT $?

  PRINT Install MongoDB Client
  dnf install mongodb-mongosh -y &>>$LOG_FILE
  STAT $?

  PRINT Load Master Data
  mongosh --host mongoDB.dev.vickydevops.online </app/db/master-data.js &>>$LOG_FILE
  STAT $?
 fi

 if [ "$schema_setup" == "MySQL" ]; then
   PRINT Install MySQL Client
   dnf install mysql -y &>>$LOG_FILE
   STAT $?


for file in schema master-data app-user; do
   PRINT Load file - $file.sql
   mysql -h MySQL.dev.vickydevops.online -uroot -pRoboShop@1 < /app/db/$file.sql &>>$LOG_FILE
   STAT $?
fi

  }




