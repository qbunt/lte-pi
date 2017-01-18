#!/usr/bin/env bash

function start {
    # starts mbim services presumably via systemd
    mbim-network /dev/cdc-wdm0 start
    echo "mobile card started..."
    ifconfig wwan0 up
    echo "wwan0 has upped..."
    dhclient wwan0
    echo "att card started and connected!"
}

function stop {
    # stops mbim services presumably via systemd
    ifconfig wwan0 down
    echo "wwan0 has downed..."
    mbim-network /dev/cdc-wdm0 stop
    echo "att card stopped and disconnected"
}

if [ $1 = "start"]; then
    start
elif [ $1 "stop"]; then
    stop
else
	echo "assuming you meant start"
	start
fi