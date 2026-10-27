#!/bin/bash

source ./common.sh

check_user

#Copying rabbit repo from local file to /etc/yum.repos.d location
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo

#Installing rabbitmq
dnf install erlang rabbitmq-server -y &>> $logs_file
validate $? "RabbitMQ installation"

#Starting Rabbitmq
systemctl enable rabbitmq-server &>> $logs_file
systemctl start rabbitmq-server &>> $logs_file
validate $? "Starting RabbitMQ"

#Checking if the user already exists or not
rabbitmqctl list_users -q | grep -qw "roboshop"
if (( $? != 0 )); then
    rabbitmqctl add_user roboshop roboshop123
    validate $? "Adding Rabbitmq User"
else
    echo -e "User already exists ... ${Y}SKIPPING${N}" | tee -a $logs_file
fi

#Setting permissions to user
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "Setting Rabbitmq Permissions"

total_time