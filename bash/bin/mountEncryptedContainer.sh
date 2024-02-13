#!/bin/bash

set -e

if [ "${#}" != 2 ]; then
   echo "Usage: mountEncryptedContainer containerName mountName";
   exit 1;
fi

echo "Mounting container '${1}' to '/mnt/${2}'";
if [[ -f ${1} ]]; then
  # This was a file.  Most likely a loopback file
  device=`sudo /usr/bin/losetup -f --show ${1}`
else
  device=${1}
fi

sudo /usr/bin/cryptsetup --type luks open ${device} ${2} &&
  sudo /usr/bin/mount /dev/mapper/${2} /mnt/${2}
