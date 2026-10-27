#!/bin/bash

app_name="shipping"

source ./common.sh

check_user

app_setup

java_setup

#Installing mysql client
dnf install mysql -y &>> $logs_file
validate $? "Installing MySQL Client"

data_count=$(mysql -h "mysql.$domain_name" -u root -pRoboShop@1 -N -B -e "SELECT COUNT(*) FROM cities.cities;" 2>> $logs_file)
if [ -z "$data_count" ] || [ "$data_count" -eq 0 ];then
    #Loading master data
    mysql -h "mysql.$domain_name" -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $logs_file
    validate $? "Loading master data"
else
    echo -e "Data already exists ... ${Y}SKIPPING${N}"
fi

#Creating app user
mysql -h "mysql.$domain_name" -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $logs_file
validate $? "Creating app user"

system_setup

restart
 
total_time