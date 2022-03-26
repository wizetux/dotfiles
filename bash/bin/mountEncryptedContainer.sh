#!/bin/bash

if [ "${#}" != 2 ]; then
   echo "Usage: mountEncryptedContainer containerName mountName";
   exit 1;
fi

echo "Mounting container '${1}' to '/mnt/${2}'";
loopBack=`sudo /usr/bin/losetup -f --show ${1}` &&
   sudo /usr/bin/cryptsetup --type luks open ${loopBack} ${2} &&
   sudo /usr/bin/mount /dev/mapper/${2} /mnt/${2}
