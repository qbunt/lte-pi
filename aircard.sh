#!/usr/bin/env bash

function start {
    # starts mbim services via systemd
    mbim-network /dev/cdc-wdm0 start
    echo "card is up and started..."
    ifconfig wwan0 up
    echo "ifconfig wwan0 has upped..."
    dhclient wwan0
    echo "card configured, started and connected"
}

function stop {
    # stops mbim services via systemd
    ifconfig wwan0 down
    echo "wwan0 is downed..."
    mbim-network /dev/cdc-wdm0 stop
    echo "lte card stopped and disconnected"
}

function check_card {
    # checks for wwan0 interface symlink listed in the file system, loops until that file can be found
    file="/sys/class/net/wwan0"
    if [ -h "$file" ]
    then
        echo "wwan0 found, starting..."
        start
    else
        echo "wwan0 not available..."
        sleep 2
        check_card
    fi
}

case "$1" in
'start')
    echo "checking for card interface..."
    check_card
    ;;
'stop')
    echo "stopping card..."
    stop
;;
'restart')
    stop
    echo "restarting aircard..."
    sleep 10
    start
;;
*)
    echo $"Usage: $0 {start|stop|restart}"
    exit 1
esac