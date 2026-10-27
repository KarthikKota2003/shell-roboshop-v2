#!/bin/bash

source ./common.sh

check_user

#Enabling and installing redis
dnf module disable redis -y &>> $logs_file
dnf module enable redis:7 -y &>> $logs_file
validate $? "Enabling redis"
dnf install redis -y &>> $logs_file
validate $? "Installing redis"

#Configuring redis
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "Configuring redis"

#Starting redis
systemctl enable redis
systemctl start redis
validate $? "Starting redis"

total_time