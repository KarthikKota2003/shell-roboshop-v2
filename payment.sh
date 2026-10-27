#!/bin/bash

app_name="payment"

source ./common.sh

check_user

app_setup

python_setup

system_setup

restart
 
total_time