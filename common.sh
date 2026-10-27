#!/bin/bash

# Creating logs folder and logs file
logs_folder="/var/log/roboshop"
logs_file=${logs_folder}/${0}.log

#Setting colors for log printing
R="\e[31m"
G="\e[32m" 
Y="\e[33m"
N="\e[0m"
B="\e[34m"

timestamp(){
    date "+%F %T"
}

#Function to validate command execution
validate(){
    if (( $1 != 0));then
        echo -e "${2} is ${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "${2} is ${G}SUCCESS${N}" | tee -a $logs_file 
    fi
}

check_user(){
    #Checking if the script is running under root user or not
    user_id=$(id -u)
    if (( $user_id != 0 )); then
        echo "This script is not running under root user, please check..." | tee -a $logs_file
    else
        echo "Running under root user..." | tee -a $logs_file
    fi
}

total_time(){
    echo "Total time for script execution is $SECONDS"
    echo -e "$(timestamp) ${B}[INFO]${N} ==== Script completed execution ====" | tee -a $logs_file
}

mkdir -p $logs_folder 

echo -e "$(timestamp) ${B}[INFO]${N} ==== Script started execution ====" | tee -a $logs_file