#!/bin/bash

source ./common.sh

#Copying mongo repo from local file to /etc/yum.repos.d location
cp mongo.repo /etc/yum.repos.d/mongo.repo

check_user

#Installing mongodb
dnf install mongodb-org -y &>> $logs_file
validate $? "Mongodb installation"

#Starting Mongodb
systemctl enable mongod &>> $logs_file
systemctl start mongod &>> $logs_file
validate $? "Starting mongodb"

#Configuring mongodb
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Configuring mongodb"

#Restarting mongodb
systemctl restart mongod &>> $logs_file
validate $? "Restarting mongodb"

total_time