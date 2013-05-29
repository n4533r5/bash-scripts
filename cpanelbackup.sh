#!/bin/bash

#This is a script to take cpanel backup with cpmove packages. Add this to cron to run daily.

# FEEL FREE TO COPY, MODIFY & DISTRIBUTE
# USE AT YOUR OWN RISK! 

for users in {`cut -d':' -f2 /etc/trueuserdomains`}
do
/scripts/pkgacct $users /disk2/cpanel >> /disk2/cpanelbackup/cpbkp.log_`date +"%m%d%Y"`
cd /disk2/cpanelbackup/
mv cpmove-$users.tar.gz $users.tar.gz.`date +"%m%d%Y"`
done
#accounts(){
#ls /disk2/cpanelbackup| grep `date +"%m%d%Y"` | grep -v log | wc -l
#}

accounts(){
ls -lhtr | grep -v total | grep -v ^dr | grep -v cpbkp.log | wc -l
}

accounts
acc=$(accounts)

#Email alert after the backup. This will attach the log file as well as Cc to another email address
echo "cPanel backup completed for total of $acc accounts. Please check the attached log for more details." | mutt -s "cPanel backup alert"  -a /disk2/cpanelbackup/cpbkp.log_`date +"%m%d%Y"` you@yourdomain.com -c me@mydomain.com


