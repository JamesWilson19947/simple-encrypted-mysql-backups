#!/bin/bash

################################################################
################## Update below values  ########################

# The directory the backups will be saved in
DB_BACKUP_PATH='backup/'

# MySQL Details to connect to database, I reccomend creating a user which only has local access which can access all schemas.
MYSQL_HOST='mysql'
MYSQL_PORT='3306'
MYSQL_USER='example'
MYSQL_PASSWORD='example'

# Database name should be inputted as param but you can override if you want
DATABASE_NAME=$1

# The path of the private key used for encryption
KEY_PATH=${DB_BACKUP_PATH}/KEY/

################################################################

TODAY=`date +"%d%b%Y"`

# Created the folders if it doesnt exist
if [ ! -d $DB_BACKUP_PATH ]
then
  mkdir -p $DB_BACKUP_PATH
fi
if [ ! -d $DB_BACKUP_PATH/BACKUPS/${TODAY} ]
then
  mkdir -p $DB_BACKUP_PATH/BACKUPS/${TODAY}
fi
if [ ! -d $KEY_PATH/ ]
then
  mkdir -p $KEY_PATH/
fi

# Creates the key if it doesnt exist
if [ ! -f "$KEY_PATH/cert.pem" ]
then
    openssl req -new -newkey rsa:2048 -nodes -x509 -keyout $KEY_PATH/key.pem -out $KEY_PATH/cert.pem -config key.conf
fi

# Dumps the MYSQL Schema
mysqldump -h ${MYSQL_HOST} \
		  -P ${MYSQL_PORT} \
		  -u ${MYSQL_USER} \
		  -p${MYSQL_PASSWORD} \
		  ${DATABASE_NAME} | gzip > ${DB_BACKUP_PATH}/BACKUPS/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz

# Encrypts the backup with the key
openssl smime -encrypt -binary -aes-256-cbc -in ${DB_BACKUP_PATH}/BACKUPS/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz -out ${DB_BACKUP_PATH}/BACKUPS/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz.enc -outform DER $KEY_PATH/cert.pem \

# Deletes the un-encrypted backup
rm ${DB_BACKUP_PATH}/BACKUPS/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz

echo 'Backed up' ${DB_BACKUP_PATH}/BACKUPS/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz.enc