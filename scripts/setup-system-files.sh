#!/usr/bin/env bash

# setup raspbian / raspberry pi configuration files
# /boot/cmdline.txt and
# /boot/config.txt
. $COMPANION_DIR/scripts/bash-helpers.sh

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

run_step sh -c "echo 'alias stopscreens=\"screen -ls | grep Detached | cut -d. -f1 | awk \\\"{print \$1}\\\" | xargs kill\"' >> ~/.bash_aliases"
run_step echo 192.168.2.2 > /home/pi/static-ip.conf

# override start timeout for networking service to prevent hang at boot in certain misconfiguraitons
run_step sudo mkdir -p /etc/systemd/system/networking.service.d
run_step sudo sh -c "echo '[Service]\nTimeoutStartSec=10' > /etc/systemd/system/networking.service.d/timeout.conf"

# setup directive to expand the filesystem on next boot (this line will delte itself after running once)
S1="$COMPANION_DIR/scripts/expand_fs.sh"

# source startup script
S2=". $COMPANION_DIR/.companion.rc"

# this will produce desired result if this script has been run already,
# and commands are already in place
# delete S1 if it already exists
# insert S1 above the first uncommented exit 0 line in the file
run_step sudo sed -i -e "\%$S1%d" \
-e "\%$S2%d" \
-e "0,/^[^#]*exit 0/s%%$S1\n$S2\n&%" \
/etc/rc.local
