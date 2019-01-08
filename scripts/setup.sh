#!/usr/bin/env bash

GIT_REPO=jaxxzer/companion
GIT_BRANCH=setup


export COMPANION_DIR=/home/pi/companion
. $COMPANION_DIR/scripts/bash-helpers.sh

# Update package lists and current packages
export DEBIAN_FRONTEND=noninteractive
APT_OPTIONS=-yq
skip_step sudo apt update $APT_OPTIONS
skip_step sudo apt upgrade $APT_OPTIONS


# install python and pip
skip_step sudo apt install $APT_OPTIONS \
  rpi-update \
  python-dev \
  python-pip \
  python-libxml2 \
  python-lxml \
  libcurl4-openssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libffi-dev \
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
  v4l-utils \
  || error "failed apt install dependencies"

# browser based terminal
skip_step sudo npm install tty.js -g || error "failed npm install dependencies"

skip_step sudo pip install \
  future \
  pynmea2 \
  grequests \
  bluerobotics-ping \
  || error "failed pip install dependencies"

skip_step sudo pip3 install future || error "failed pip3 install dependencies"

# clone bluerobotics companion repository
skip_step git clone --depth 1 -b $GIT_BRANCH https://github.com/$GIT_REPO $COMPANION_DIR || error "failed git clone"

skip_step cd $COMPANION_DIR

skip_step git submodule update --init --recursive || "error failed submodule update"

skip_step cd $COMPANION_DIR/submodules/mavlink/pymavlink
skip_step python3 setup.py build || "error failed "
skip_step sudo python3 setup.py install || "error failed "

skip_step cd $COMPANION_DIR/submodules/MAVProxy
skip_step python setup.py build
skip_step sudo python setup.py install

skip_step cd $COMPANION_DIR/br-webui
skip_step npm install

run_step $COMPANION_DIR/scripts/setup-raspbian.sh
run_step $COMPANION_DIR/scripts/setup-system-files.sh

# run rpi update
run_step rpi-update
