#!/bin/bash

source ./common.sh

check_user

#Enabling and installing mysql
dnf module enable mysql:8.4 -y &>> $logs_file
dnf install mysql-server -y &>> $logs_file
validate $? "Installing mysql"

#Starting mysql
systemctl enable mysqld
systemctl start mysqld
validate $? "Starting mysql"

#Setting mysql root password
mysql_secure_installation --set-root-pass RoboShop@1
validate $? "Setting MySQL root password"

total_time