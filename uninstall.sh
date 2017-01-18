#!/usr/bin/env bash
sudo -v
# prompt the user for root creds
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "stopping and disabling aircard.service..."
sudo systemctl stop aircard.service
sudo systemctl disable aircard.service
echo "disconnecting card"
sudo mbim-network /dev/cdc-wdm0 stop
echo "card has stopped, removing aircard install..."
sudo rm -rf /usr/bin/aircard.sh
sudo rm -rf /lib/systemd/system/aircard.service
echo "removing mbim config..."
sudo rm -rf /etc/mbim-network.conf
echo "uninstall complete"