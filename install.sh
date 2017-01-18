#!/usr/bin/env bash
sudo -v
# prompt the user for root creds
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo cp aircard.sh /usr/bin/aircard.sh
sudo cp aircard.service /lib/systemd/system/aircard.service

# run a repo update
sudo apt-get update

# check for libmbim-utils install
if [ $(dpkg-query -W -f='${Status}' libmbim-utils 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "installing mbim-utils..."
    sudo apt-get install libmbim-utils;
    echo "mbim-utils install completed..."
fi

echo "adding mbim-network configuration..."
# escalate perms up to root to inject the mbim config
sudo su
# check for existing of the file
file="/etc/mbim-network.conf"
if [ -f "$file" ]
then
    # file HAS been found at location
	echo "$file found, skipping to start..."
else
    # file HAS NOT been found at location
	echo "$file not found, writing file..."
	echo "APN=Broadband" > /etc/mbim-network.conf
fi
# de-escalate for running the service
exit

# enable the aircard service with systemd
systemctl enable aircard.service
# kick start aircard service with systemd
systemctl start aircard.service

echo "aircard install complete..."
echo "aircard service started and enabled, verify LTE card has connected, then reboot"
