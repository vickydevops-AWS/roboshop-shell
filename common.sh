NODEJS() {
  dnf module disable nodejs -y
  dnf module enable nodejs:20 -y
  dnf install nodejs -y
  cp ${component}.service /etc/systemd/system/${component}.service
  cp Mongo.repo /etc/yum.repos.d/mongo.repo
  useradd roboshop
  rm -rf /app
  mkdir /app
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
  cd /app
  unzip /tmp/${component}.zip
  cd /app
  npm install
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}