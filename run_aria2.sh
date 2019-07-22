#!/bin/bash

LOG_PATH=/var/log/aria2
echo $LOG_PATH

mkdir $LOG_PATH -p

LOG_FILE="$LOG_PATH/aria2.log"
/usr/bin/aria2c --conf-path=/home/atguigu/.aria2/aria2.conf >> $LOG_FILE 2>&1 & echo $! > pidfile.txt

