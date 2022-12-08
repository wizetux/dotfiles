#!/bin/bash

usage() {
  echo "Usage: syncKeepass.sh remote_dir [source_dir]"
  echo "    remote_dir: The location you are syncing with.  This is unusually the USB drive"
  echo "    source_dir: The source location. Defaults to users home dir"
}

exit_abnormal() {
  usage
  exit 1
}

if [[ ${#} -lt 1 || ${#} -gt 2 ]]; then
  exit_abnormal
elif [[ ${#} -eq 1 ]]; then
  echo "Using $HOME as the source location"
  sourceDir=$HOME
else
  sourceDir=$(dirname $2)"/"$(basename $2)
fi

destinationDir=$(dirname $1)"/"$(basename $1)

if [[ ! -d $destinationDir ]]; then
  echo "Destination directory: $destinationFile does not exist"
  exit 1
fi

writeable=true
if [[ ! -w $destinationDir ]]; then
  echo "User doesn't have permissions to write to $destinationFile"
  writeable=false
fi

if [[ ! -d $sourceDir ]]; then
  echo "Source directory: $destinationFile does not exist"
  exit 1
fi

files=(personal.kdbx accretivetg.kdbx)

for file in ${files[@]}; do
  destinationFile="${destinationDir}/${file}"
  sourceFile="${sourceDir}/${file}"

  if [[ ! -f $destinationFile && ! -f $sourceFile ]]; then
    echo "File $file doesn't exist in either $destinationDir or $sourceDir"
    continue
  elif [[ ! -e $destinationFile || ! -f $destinationFile ]]; then
    echo "Copying $sourceFile -> $destinationFile since the destination file did not exist"
    cp -a $sourceFile $destinationFile
    continue
  elif [[ ! -e $sourceFile || ! -f $sourceFile ]]; then
    echo "Copying $destinationFile -> $sourceFile since the source file did not exist"
    cp -a $destinationFile $sourceFile
    continue
  fi

  # Destination file exists. Lets determine if the source is newer than the destination
  if [[ $sourceFile -nt $destinationFile ]]; then
    echo "Copying $sourceFile -> $destinationFile since the destination is older"
    if $writeable; then
      cp -a $sourceFile $destinationFile
    fi
  elif [[ $destinationFile -nt $sourceFile ]]; then
    echo "Copying $destinationFile -> $sourceFile since the source is older"
    cp -a $destinationFile $sourceFile
  else
    echo "The source and destination have the same timestamp"
  fi
done

exit 0
