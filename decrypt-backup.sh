#!/bin/bash

################################################################
################## Update below values  ########################

# Where the backups are
DB_BACKUP_PATH='backup/'
# The path of the private key used for encryption
KEY_PATH=${DB_BACKUP_PATH}/KEY/

################################################################
output=$(echo "$1" | cut -f 1 -d '.').sql.gz
openssl smime -decrypt -in $1 -binary -inform DEM -inkey $KEY_PATH/key.pem -out $output
 gunzip $output && echo "File has been decrypted"