#!/bin/bash

if [ "${#}" != 1 ]; then
   echo "Usage: ${0} containerName ";
   exit 1;
fi

echo "Unmounting container '${1}'";
loopBack=`sudo /usr/bin/cryptsetup status ${1} | grep device | cut -f 2 -d : | tr -d '[:space:]'`
sudo umount /mnt/${1} &&
   sudo /usr/bin/cryptsetup close ${1} &&
   sudo /usr/bin/losetup -d ${loopBack}
