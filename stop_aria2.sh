#!/bin/bash

pid=`cat pidfile.txt`
ps -p $pid && kill -9 $pid && echo "kill $pid"
