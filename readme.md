# lte-pi
A simple systemd unit file and service for the AT&T aircard 340U LTE card.

This project is intended for use on the Raspberry Pi 3 running modern Debian (this was tested extensively on Jessie). This will run an Netgear / AT&T Aircard 340U USB LTE card well in a situation where you need a Pi to run on LTE.


<img src="example.jpg" alt="example of card in action" width="400px">


## Install
Clone the repo (or copy it via flash drive)
```bash
./install.sh
```

## Uninstall
```bash
./uninstall.sh
```
If you don't see the card connected on the card's display, run `reboot` and check for a connection on the card's display

---
The above commands should be all you need, however, if you need to manually start or stop the services, this is how that works.

## Manual Start
Note: You shouldn't need to do run either of these unless something goes wrong
```bash
sudo systemctl start aircard.service
```

## Manual Stop
```bash
sudo systemctl stop aircard.service
```

## If systemctl isn't available
```bash
// 'start','stop' or 'restart'
sudo /usr/bin/aircard.sh start
```

## License
[MIT](LICENSE)

## Contributors
[qbunt](https://qbunt.com)
