#!/bin/bash
## tmpwatch is a program to automatically delete unused tmp files and thus by freeing up the disk space in /tmp

# FEEL FREE TO COPY, MODIFY & DISTRIBUTE
# USE AT YOUR OWN RISK! 

/usr/sbin/tmpwatch --mtime --all 336 /tmp

## Add this file to /etc/cron.weekly and make it executable
## ( 24 hours * 14 days ) = 336 hours which is what we are using
## This will remove all files not accessed within last 336 hours
