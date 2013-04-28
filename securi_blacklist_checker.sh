#!/bin/bash
## This is a simple script for checking whether your site is blacklisted in major search engines like Google
## and major Antivirus scanners using securi site scanner service

# FEEL FREE TO COPY, MODIFY & DISTRIBUTE           
# USE AT YOUR OWN RISK! 

## You can add this script to a cron job to get timely alerts

## change yoursite.com to the site which you want to monitor

for SITE in {www.yoursite.com,yoursite.com} 
do
echo "                                    " >> /tmp/securi.txt ##just for formating the results
curl -s http://sitecheck.sucuri.net/results/$SITE  | grep 'Blacklisted:' -C 1 |  sed 's/<[^>]\+>//g' | sed -e 's/:/ /g'  -e 's/;/ /g' | grep 'Yes' > /dev/null && echo "$SITE is blacklisted" >> /tmp/securi.txt || echo "$SITE is not blaclisted" >> /tmp/securi.txt
echo "                                   " >> /tmp/securi.txt  ## just for formating the results
echo "For more information, please visit the url: http://sitecheck.sucuri.net/results/$SITE" >> /tmp/securi.txt
done
## in the below command, change you@domain.com to the email address you want to receive the alerts
mail -s "Securi site blacklist status for $SITE" you@domain.com < /tmp/securi.txt 
rm -f /tmp/securi.txt ## to remove the results file after sending mail so that we can start it fresh next time 

# ***** script ends here *****

## This script will send mail even if the site is not blacklisted 
## Need to modify the script to only send mail if one of the site is blacklisted
