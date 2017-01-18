#!/usr/bin/env bash

function start {
    # starts mbim services presumably via systemd
    echo "waiting for to come up..."
    mbim-network /dev/cdc-wdm0 start
    echo "card is up and started..."
    ifconfig wwan0 up
    echo "ifconfig wwan0 has upped..."
    dhclient wwan0
    echo "card configured, started and connected"
}

function stop {
    # stops mbim services presumably via systemd
    ifconfig wwan0 down
    echo "wwan0 has downed..."
    mbim-network /dev/cdc-wdm0 stop
    echo "att card stopped and disconnected"
}

function check_card {
    file="/sys/class/net/wwan0"
    if [ -h "$file" ]
    then
        echo "$file found."
        start
    else
        echo "$file not found."
        sleep 2
        check_card
    fi
}

case "$1" in
'start')
    echo "starting card if up..."
    check_card
    ;;
'stop')
    echo "stopping card..."
    stop
;;
'restart')
    stop
    echo "restarting aircard..."
    start
;;
*)
    echo $"Usage: $0 {start|stop|restart}"
    exit 1
esac