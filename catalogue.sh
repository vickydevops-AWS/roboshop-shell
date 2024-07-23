cp catalogue.service /etc/systemd/system/catalogue.service
cp Mongo.repo /etc/yum.repos.d/mongo.repo
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
useradd roboshop
rm -rf /app
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
dnf install mongodb-mongosh -y
mongosh --host mongoDB.dev.vickydevops.online </app/db/master-data.js
