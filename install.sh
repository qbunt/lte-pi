#!/usr/bin/env bash
sudo -v
# prompt the user for root creds
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "copying service files..."
sudo cp aircard.sh /usr/bin/aircard.sh
sudo cp aircard.service /lib/systemd/system/aircard.service
sudo chmod +x /usr/bin/aircard.sh

# check for libmbim-utils install
if [ $(dpkg-query -W -f='${Status}' libmbim-utils 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "installing mbim-utils..."
    # run a repo update
    sudo apt-get update
    # install mbim
    sudo apt-get -y install libmbim-utils;
    echo "mbim-utils install completed..."
fi

echo "adding mbim-network configuration..."
# check for existence of the file
file="/etc/mbim-network.conf"
if [ -f "$file" ]
then
    # file found, no config needed
	echo "$file interface is up, skipping to start..."
else
    # file NOT found, copying config
	echo "$file interface is not up, writing..."
	sudo cp mbim-network.conf /etc/mbim-network.conf
	sudo chown root:root /etc/mbim-network.conf
fi

# enable the aircard service
sudo systemctl enable aircard.service
file="/sys/class/net/wwan0"
if [ -h "$file" ]
then
    # kick start aircard service with systemd
    echo "card found, starting service..."
    sudo systemctl start aircard.service
else
    echo "card not found, skipping start"
fi

echo "aircard install complete..."
echo "aircard service started and enabled, verify LTE card has connected or reboot to connect automatically"

exit