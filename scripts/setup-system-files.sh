#!/usr/bin/env bash

# setup raspbian / raspberry pi configuration files
# /boot/cmdline.txt and
# /boot/config.txt
. bash-helpers.sh

run_step echo "" > /etc/wpa_supplicant/wpa_supplicant.config

#Copy network configuration files from Companion directory to respective configuration directories
run_step sudo cp /home/pi/companion/params/interfaces-eth0 /etc/network/interfaces.d/

#Source configuration for dhcp server in the default configuration files
run_step sudo sed -i '\%/home/pi/companion/%d' /etc/dhcp/dhcpd.conf
run_step sudo sh -c "echo 'include \"/home/pi/companion/params/dhcpd-server.conf\";' >> /etc/dhcp/dhcpd.conf"

run_step sudo sed -i '\%/home/pi/companion/%d' /etc/default/isc-dhcp-server
run_step sudo sh -c "echo '. /home/pi/companion/params/isc-dhcp.conf' >> /etc/default/isc-dhcp-server"

#Copy default network configuration to user folder
run_step cp /home/pi/companion/params/network.conf.default /home/pi/network.conf


run_step echo "alias stopscreens=\"screen -ls | grep Detached | cut -d. -f1 | awk '{print \$1}' | xargs kill\"" >> ~/.bash_aliases
run_step echo 192.168.2.2 > /home/pi/static-ip.conf

# override start timeout for networking service to prevent hang at boot in certain misconfiguraitons
run_step sudo mkdir -p /etc/systemd/system/networking.service.d
run_step sudo sh -c "echo '[Service]\nTimeoutStartSec=10' > /etc/systemd/system/networking.service.d/timeout.conf"
