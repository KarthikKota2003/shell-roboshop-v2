#!/bin/bash

app_name="catalogue"

source ./common.sh

check_user

app_setup

nodejs_setup

system_setup

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo

#Installing MongoDB client
dnf install mongodb-mongosh -y &>> $logs_file
validate $? "Installing MongoDB Client"

#Checking if data exists or not
if (( $(mongosh --host "mongodb.$domain_name" --quiet --eval 'db.getSiblingDB("catalogue").products.countDocuments()') != 11 ));then
    #Loading Data
    mongosh --host "mongodb.$domain_name" </app/db/master-data.js &>> $logs_file
    validate $? "Loading Data into MongoDB"
else
    echo -e "Data already exists ... ${Y}SKIPPING${N}"
fi

restart

total_time