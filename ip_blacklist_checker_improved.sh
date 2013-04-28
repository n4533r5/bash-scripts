#!/bin/bash

## This is an improved version of my previous script. 
## This script will email you only if one of the IP is blacklisted in any one (or both) of the blacklists.
## Previous version can be found here: https://github.com/n4533r5/bash-scripts/blob/master/ip_blacklist_checker.sh

## This is a simple script to check whether your Server IP is blacklisted in SpamCop and Cisco IronPort for sending spam mails.
## You can add this script to cron job and get regular alerts.
## This will help you identify the issue and fix it before your customers are complaining about failed emails.

# FEEL FREE TO COPY, MODIFY & DISTRIBUTE
# USE AT YOUR OWN RISK!


# Change you@domain.com to the email address to which you need to receive the alerts.
email=you@domain.com 
rm -f /tmp/blstatus.txt


# Change the serverip1,serverip2 etc to your server's original IPs.
for IP in {serverip1,serverip2}
do


# function to check the blacklist status in SpamCop.
spamcop(){
curl -s  "http://spamcop.net/w3m?action=checkblock&amp;ip=$IP" | grep $IP | grep bl.spamcop.net | grep "$IP listed" >> /dev/null
}


# function to check the blacklist status in Cisco IronPort.
ironport(){
curl -s --request POST http://www.senderbase.org/senderbase_queries/rep_lookup? --data "search_name=$IP&action%3ASearch=Search" | grep "Email Reputation Score" -C 1 | grep Poor >> /dev/null
}


# Formating the email for readability.
echo "Hello," >> /tmp/blstatus.txt
echo " " >> /tmp/blstatus.txt
echo "You have received this mail because one of your Servers is being used for spamming and being blacklisted. Below given is the details of the server being blacklisted" >> /tmp/blstatus.txt
echo " " >> /tmp/blstatus.txt
echo " " >> /tmp/blstatus.txt
echo " " >> /tmp/blstatus.txt


spamcop

spamcop_status=$?

# If exit status is 0, then the server is blacklisted.
if [ $spamcop_status -eq 0  ]
then
echo "The server with IP $IP is blacklisted in SpamCop. It means that your server is sending spam mails. Stop spamming in your server and whitelist it in : http://www.spamcop.net/bl.shtml" >> /tmp/blstatus.txt
echo " " >> /tmp/blstatus.txt
fi


ironport

ironport_status=$?

# If exit status is 0, then the server is blacklisted.
if [ $ironport_status -eq 0 ]
then
echo "The server with IP $IP has Poor reputation in Cisco Ironport. It means that your server is sending spam mails. Stop spamming in your server. For more details click: http://www.senderbase.org/senderbase_queries/detailip?search_string=$IP" >> /tmp/blstatus.txt
echo " " >> /tmp/blstatus.txt
fi



spamalert=`expr $spamcop_status + $ironport_status`

# If the sum of exit status of both blacklists is less than 2, IP is blacklisted in one of ( or both) blacklists. In this case, send the alert mail.
if [ $spamalert -lt 2 ]
then
mail -s "Important :: Your server with IP $IP is blacklisted" $email < /tmp/blstatus.txt
rm -f /tmp/blstatus.txt
fi


done

