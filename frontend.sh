#!/bin/bash

source ./common.sh

check_user

#Installing Nginx
dnf module disable nginx -y &>> $logs_file
dnf module enable nginx:1.26 -y &>> $logs_file
dnf install nginx -y &>> $logs_file
validate $? "Installing Nginx"

#Starting Nginx
systemctl enable nginx &>> $logs_file
systemctl start nginx &>> $logs_file
validate $? "Starting Nginx"

#Remove default content
rm -rf /usr/share/nginx/html/* &>> $logs_file

#Downloading and Extracting frontend content
curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip &>> $logs_file
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> $logs_file
validate $? "Downloading and Extracting frontend content"

#Configuring roboshop.conf file
sed -i "s/DOMAIN_NAME/$domain_name/g" $script_dir/roboshop.conf
cp $script_dir/roboshop.conf /etc/nginx/default.d/roboshop.conf
validate $? "Configuring roboshop.conf"

nginx -t &>> $logs_file
validate $? "Validating Reverse Proxy Syntax"

systemctl restart nginx
validate $? "Restarting nginx"
 

total_time