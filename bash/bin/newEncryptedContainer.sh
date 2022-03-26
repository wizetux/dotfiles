#!/bin/bash

if [ "${#}" != 2 ]; then
   echo "Usage: ${0} containerName sizeInMegabytes";
   return 1;
fi

echo "Creating container '${1}' of size '${2}' megabytes";
containerName=${1}
dd if=/dev/urandom of=${1} bs=1M count=${2};
loopBack=`sudo /usr/bin/losetup -f --show ${1}`;
echo "Connected container ${1} to loop back device ${loopBack}";
echo "Creating LUKs on container"
sudo /usr/bin/cryptsetup -v luksFormat ${loopBack};
echo "Opening container in order to format..."
sudo /usr/bin/cryptsetup --type luks open ${loopBack} 'new_container'

if [[ $? != 0 ]] ; then
   echo "Failed to open container"
   exit 1
fi

echo "Formatting ${containerName} with ext4"
sudo /usr/bin/mkfs.ext4 /dev/mapper/new_container
echo "Closing new container: ${containerName}"
sudo /usr/bin/cryptsetup close 'new_container';
echo "Removing loopback setup for ${loopBack}"
sudo /usr/bin/losetup -d ${loopBack}
