#!/usr/bin/env bash

# RPi2 setup script for use as companion computer. This script is simplified for use with
# the ArduSub code.
cd $HOME

# Update package lists and current packages
export DEBIAN_FRONTEND=noninteractive
APT_OPTIONS=-yq
apt update $APT_OPTIONS
apt upgrade $APT_OPTIONS


# install python and pip
apt install $APT_OPTIONS \
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
  gstreamer1.0-[^omx] \
  isc-dhcp-server=4.3.* \
  python3-pip \
  libv4l-dev

# browser based terminal
npm install tty.js -g

pip install \
  future \
  pynmea2 \
  grequests \
  bluerobotics-ping

pip3 install future

# clone bluerobotics companion repository
git clone https://github.com/bluerobotics/companion.git $HOME/companion

cd $HOME/companion

git submodule update --init --recursive

cd $HOME/companion/submodules/mavlink/pymavlink
python3 setup.py build install

cd $HOME/companion/submodules/MAVProxy
python setup.py build install

cd $HOME/companion/br-webui
npm install

$HOME/companion/scripts/setup-raspbian.sh
$HOME/companion/scripts/setup-system-files.sh

# run rpi update
rpi-update
