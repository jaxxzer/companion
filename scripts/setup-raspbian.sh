#!/usr/bin/env bash

# setup raspbian / raspberry pi configuration files
# /boot/cmdline.txt and
# /boot/config.txt

. $COMPANION_DIR/scripts/bash-helpers.sh

# Disable camera LED
run_step sudo sed -i '\%disable_camera_led=1%d' /boot/config.txt
run_step sudo sed -i '$a disable_camera_led=1' /boot/config.txt

# Enable RPi camera interface
run_step sudo sed -i '\%start_x=%d' /boot/config.txt
run_step sudo sed -i '\%gpu_mem=%d' /boot/config.txt
run_step sudo sed -i '$a start_x=1' /boot/config.txt
run_step sudo sed -i '$a gpu_mem=128' /boot/config.txt

#Delete ip address if present from /boot/cmdline.txt
# e.g. sed command removes any ip address with any combination of digits [0-9] between decimal points
run_step sudo sed -i -e 's/\s*ip=[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//' /boot/cmdline.txt

# remove any line containing 'enable_uart=' from /boot/config.txt
run_step sudo sed -i '/enable_uart=/d' /boot/config.txt

# append 'enable_uart=1' line to /boot/config.txt
run_step echo "enable_uart=1" | sudo tee -a /boot/config.txt

# run rpi update
run_step sudo rpi-update
