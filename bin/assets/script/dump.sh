#!/bin/sh

# This script will backup one or more mySQL databases
# and then optionally email them and/or FTP them

# This script will create a different backup file for each database by day of the week
# i.e. 1-dbname1.sql.gz for database=dbname1 on Monday (day=1)
# This is a trick so that you never have more than 7 days worth of backups on your FTP server.
# as the weeks rotate, the files from the same day of the prev week are overwritten.

############################################################
#===> site-specific variables - customize for your site

# List all of the MySQL databases that you want to backup in here,
# each seperated by a space
databases="v3_testing_deploy"

# Directory where you want the backup files to be placed
backupdir=/root/db

# MySQL dump command, use the full path name here
mysqldumpcmd=/usr/bin/mysqldump
# enter when use password in sh
user=""
password=""
# enter when keep in a file recommend:
# File .myprivate with 0600 permission
# [mysqldump]             # NEEDED FOR DUMP
#user=username
# password=password
authfile="/root/"
authByFile=1
# MySQL Username and password

if [ $authByFile -gt 1 ]; then
   auth=" --defaults-extra-file=$authfile "
else
   auth=" --user=$user --password=$password"
fi

# MySQL dump options
dumpoptions=" --quick --add-drop-table --add-locks --extended-insert --lock-tables"

# Unix Commands
gzip=/bin/gzip
uuencode=/usr/bin/uuencode
mail=/bin/mail

# Send Backup?  Would you like the backup emailed to you?
# Set to "y" if you do
sendbackup="n"
subject="Backup is done"
mailto="email@domain.tld"

#===> site-specific variables for FTP Use FQDN or IP
ftpbackup="n"
ftpserver="ftp.domain.tld"
ftpuser="ftp_username"
ftppasswd="ftp_pass"
# If you are keeping the backups in a subdir to your FTP root
ftpdir="/"

#===> END site-specific variables - customize for your site
############################################################

# Get the Day of the Week (0-6)
# This allows to save one backup for each day of the week
# Just alter the date command if you want to use a timestamp
DOW=$(date +"%Y-%m-%d %H:%M:%S")

# Create our backup directory if not already there
mkdir -p ${backupdir}
if [ ! -d ${backupdir} ]; then
   echo "Not a directory: ${backupdir}"
   exit 1
fi

# Dump all of our databases
echo "Dumping MySQL Databases"
for database in $databases; do
   $mysqldumpcmd $auth $dumpoptions $database >${backupdir}/${DOW}-${database}.sql
done

# Compress all of our backup files
echo "Compressing Dump Files"
for database in $databases; do
   rm -f ${backupdir}/${DOW}-${database}.sql.gz
   $gzip ${backupdir}/${DOW}-${database}.sql
done

# Send the backups via email
if [ $sendbackup = "y" ]; then
   for database in $databases; do
      $uuencode ${backupdir}/${DOW}-${database}.sql.gz >${backupdir}/${DOW}-${database}.sql.gz.uu
      $mail -s "$subject : $database" $mailto <${backupdir}/${DOW}-${database}.sql.gz.uu
   done
fi

# FTP it to the off-site server
echo "FTP file to $ftpserver FTP server"
if [ $ftpbackup = "y" ]; then
   for database in $databases; do
      echo "==> ${backupdir}/${DOW}-${database}.sql.gz"
      ftp -n $ftpserver <<EOF
user $ftpuser $ftppasswd
bin
prompt
cd $ftpdir
lcd ${backupdir}
put ${DOW}-${database}.sql.gz
quit
EOF
   done
fi

# And we're done
ls -l ${backupdir}
echo "Dump Complete!"
exit
