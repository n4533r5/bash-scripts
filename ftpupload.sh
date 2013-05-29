#/bin/bash
#FTP backup script using NcFTP which has features like recursive transfer,resuming failed transfer etc. It also supports interactive mode as well as scripting mode.
# We are using ncftpput for uploading files to remote ftp location.

# FEEL FREE TO COPY, MODIFY & DISTRIBUTE
# USE AT YOUR OWN RISK! 

FTPU="yourftpusername" # ftp login name
FTPP="yourftppassword" # ftp password
FTPS="yourftpserverip" # remote ftp server
FTPF="/remoteftp/cpanelbackup/" # remote ftp server directory for $FTPU & $FTPP

## The below command will upload tar.gz files from the location /disk2/cpanelbackup in our local machine
## to remote ftp location /remoteftp/cpanelbackup

ncftpput -m -u $FTPU -p $FTPP $FTPS  $FTPF /disk2/cpanelbackup/*.tar.gz.* 

