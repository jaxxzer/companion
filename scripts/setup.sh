#!/usr/bin/env bash

COMPANION_DIR=/home/pi/companion

# Update package lists and current packages
export DEBIAN_FRONTEND=noninteractive
APT_OPTIONS=-yq
sudo apt update $APT_OPTIONS
sudo apt upgrade $APT_OPTIONS


# install python and pip
sudo apt install $APT_OPTIONS \
  rpi-update \
  python-dev \
  python-pip \
  python-libxml2 \
  python-lxml \
  libcurl4-openssl-dev \
  libxml2-dev \
  libxslt1-dev \
  git \
  screen \
  nodejs \
  npm \
  gstreamer1.0-tools \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  isc-dhcp-server=4.3.* \
  python3-pip \
  libv4l-dev \
  v4l-utils

# browser based terminal
sudo npm install tty.js -g

sudo pip install \
  future \
  pynmea2 \
  grequests \
  bluerobotics-ping

sudo pip3 install future

# clone bluerobotics companion repository
git clone https://github.com/bluerobotics/companion.git $COMPANION_DIR

cd $COMPANION_DIR

git submodule update --init --recursive

cd $COMPANION_DIR/submodules/mavlink/pymavlink
sudo python3 setup.py build install

cd $COMPANION_DIR/submodules/MAVProxy
sudo python setup.py build install

cd $COMPANION_DIR/br-webui
npm install

$COMPANION_DIR/scripts/setup-raspbian.sh
$COMPANION_DIR/scripts/setup-system-files.sh

# run rpi update
rpi-update
