#!/bin/bash

## This is a simple script to check whether your Server IP is blacklisted in SpamCop and Cisco IronPort for sending spam mails. 
## You can add this script to cron job and get regular alerts.
## This will help you identify the issue and fix it before your customers are complaining about failed emails.

# FEEL FREE TO COPY, MODIFY & DISTRIBUTE           
# USE AT YOUR OWN RISK! 

## Change serverip1,serverip2 etc to your server's original IPs


for IP in {serverip1,serverip2}
do
if
curl -s  "http://spamcop.net/w3m?action=checkblock&amp;ip=$IP" | grep $IP | grep bl.spamcop.net | grep "$IP listed" >> /dev/null
then
echo "$IP is blacklisted in SpamCop. Your server is sending spam mails. Stop spamming in your server and whitelist it in : http://www.spamcop.net/bl.shtml" >> /tmp/blstatus.txt
else
echo "$IP not blacklisted in SpamCop" >> /tmp/blstatus.txt
fi
echo "                                                 " >> /tmp/blstatus.txt
if
curl -s --request POST http://www.senderbase.org/senderbase_queries/rep_lookup? --data "search_name=$IP&action%3ASearch=Search" | grep "Email Reputation Score" -C 1 | grep Poor >> /dev/null
then
echo "$IP has Poor reputation in Ironport. It means that your server is sending spam mails. Stop spamming in your server. For more details click: http://www.senderbase.org/senderbase_queries/detailip?search_string=$IP" >> /tmp/blstatus.txt
else
echo "$IP reputation is OKAY" >> /tmp/blstatus.txt
fi
echo "-------------------------------------------------" >> /tmp/blstatus.txt
echo "                                                 " >> /tmp/blstatus.txt
done
mail -s "IP reputation and blacklist status" you@domain.com < /tmp/blstatus.txt ## Change you@domain.com to your email address to receive the alerts
rm -f /tmp/blstatus.txt

## In future, need to modify the script to get alerts only if one of the IPs is blacklisted.
## Also need to find a way to add the MXtoolbox blacklist checking (http://mxtoolbox.com/blacklists.aspx) to this script.
## If you know any way, please let me know.


