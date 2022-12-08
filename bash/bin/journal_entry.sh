#!/bin/bash

year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
noteFileDir=$HOME/journal/${year}/${month}
noteFileName=${noteFileDir}/${day}.md

if [ ! -d ${noteFileDir} ]; then
  mkdir -p ${noteFileDir}
fi

if [ ! -e ${noteFileName} ]; then
  echo "# Journal entry for ${month}/${day}/${year}" >> ${noteFileName}
fi

st -t "journal entry" nvim -c "norm Go" -c "norm Go## $(date +%H:%M)" -c "norm G2o" -c "norm zz" -c "startinsert" ${noteFileName}


