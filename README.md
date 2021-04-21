# simple-encrypted-mysql-backups

This is a really simple way to backup MYSQL schemas and encrypt them with a private key so that they could be transported somewhere else like AWS.

There is 3 scripts currently.

./backup.sh
./decrypt-backup.sh
./backup-all.sh

## Backup.sh

To use this open up ./backup.sh
Change the DB_BACKUP_PATH to somewhere you want to save the backups.
Change MYSQL Details to be a user which has access to the MYSQL schemas.
Change the KEY_PATH to where you want to save the encrypted key which will encrypt the backups.

To use the script you need to type
./backup.sh <schema_name>

This will backup the database, encrypt and save it.

## Decrypt-backup.sh

Open up this file, change the KEY_PATH to where the key is saved which encrypted the files.
DB_BACKUP_PATH is where the backups are stored.

Simply run ./decrypt-backup.sh <path/to/file>

Example:
./decrypt-backup.sh EXAMPLE/BACKUPS/21Apr2021/schema.sql.gz.enc

The file will be saved in the same directory as schema.sql

## Backup-all.sh
This is just a simple array, you just need to add your schemas in that array and then run it, it will loop through all the schemas in an array to make a backup. You could use this for example and put it on the cron this would then backup all your schemas.

## key.conf
Edit this file to adjust the parameters of the private / encrypted key it will generate.