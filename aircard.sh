#!/usr/bin/env bash
sudo -v

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo apt-get update

if [ $(dpkg-query -W -f='${Status}' libmbim-utils 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "installing mbim-utils..."
    apt-get install libmbim-utils;
    echo "mbim-utils install completed..."
fi

sudo su

file="/etc/mbim-network.conf"
if [ -f "$file" ]
then
	echo "$file found, skipping to start..."
else
	echo "$file not found, generating..."
	echo "APN=Broadband" > /etc/mbim-network.conf
fi

mbim-network /dev/cdc-wdm0 start
echo "mobile card started..."
ifconfig wwan0 up
echo "wwan0 has upped..."
dhclient wwan0
echo "att card started and connected"

