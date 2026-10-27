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

app_setup(){
    #Creating system user
    id roboshop &>> $logs_file
    if (( $? != 0 ));then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        validate $? "Creating System User"
    else
        echo -e "User already exists ... ${Y}SKIPPING${N}" 
    fi

    #Removing old code
    rm -rf /app
    validate $? "Removing Old Code"

    #Creating app directory
    mkdir -p /app
    validate $? "Creating App Directory"

    #Downloading and unzipping code
    curl -L -o /tmp/"$app_name".zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/"$app_name"-v4.zip &>> $logs_file
    cd /app
    unzip /tmp/"$app_name".zip &>> $logs_file
    validate $? "Unzipping code"
}

system_setup(){
    #Creating SystemD file
    sed -i "s/DOMAIN_NAME/$domain_name/g" "$script_dir"/"$app_name".service
    cp $script_dir/"$app_name".service /etc/systemd/system/"$app_name".service

    #Starting catalogue service
    systemctl daemon-reload
    systemctl enable "$app_name" &>> $logs_file
    systemctl start "$app_name"
    validate $? "Starting "$app_name" Service"
}

nodejs_setup(){
    #Installing Nodejs
    dnf module disable nodejs -y &>> $logs_file
    dnf module enable nodejs:24 -y &>> $logs_file
    dnf install nodejs -y &>> $logs_file
    validate $? "Installing Nodejs"

    #Installing dependencies
    npm install &>> $logs_file
    validate $? "Installing dependencies"
}

restart(){
    #Restarting catalogue service to refresh service file again
    systemctl restart "$app_name"
    validate $? "Restarting $app_name"
}

mkdir -p $logs_folder 

echo -e "$(timestamp) ${B}[INFO]${N} ==== Script started execution ====" | tee -a $logs_file