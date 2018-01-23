#!/bin/bash
cd /home/jack/companion

echo 'validating archive'
if unzip -l $1 | grep -q companion/.git; then
    echo 'archive validated ok'
else
    echo 'Archive does not look like a companion update!'
    exit 1
fi

echo 'adding lock'
touch /home/jack/.updating

echo 'removing old backup'
rm -rf /home/jack/.companion

echo 'backing up repository'
mv /home/jack/companion /home/jack/.companion

echo 'extracting archive: ' $1
unzip -q $1 -d /home/jack

echo 'running post-sideload.sh'
/home/jack/companion/scripts/post-sideload.sh
