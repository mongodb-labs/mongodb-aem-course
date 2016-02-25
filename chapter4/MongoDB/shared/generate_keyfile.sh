#!/bin/sh
keyfile=aem-replica-keyfile
if [ ! -z $1 ]
then
    keyfile=$1
fi
openssl rand -base64 741 > $keyfile
chmod 600 $keyfile
echo "Generated `readlink -f $keyfile`"
