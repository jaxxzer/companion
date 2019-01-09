#!/usr/bin/env bash

GIT_REPO=jaxxzer/companion
GIT_BRANCH=setup

export COMPANION_DIR=/home/pi/companion
. ./bash-helpers.sh

# Update package lists and current packages
export DEBIAN_FRONTEND=noninteractive
APT_OPTIONS=-yq
run_step sudo apt update $APT_OPTIONS
run_step sudo apt upgrade $APT_OPTIONS

# install python and pip
run_step sudo apt install $APT_OPTIONS \
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

run_step sh -c "wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash"

# to use nvm
run_step . ~/.nvm/nvm.sh

run_step nvm install 11.6.0

# see https://stackoverflow.com/a/29903645
run_step export NODEINSTALL=$(which node)
run_step export NODEINSTALL=${NODEINSTALL%/bin/node}
# had to use 777 instead of 755 so 'sudo npm install -g' will work
run_step chmod -R 777 $NODEINSTALL/bin/*
run_step sudo cp -r $NODEINSTALL/{bin,lib,share} /usr/local

# browser based terminal
run_step sudo npm install tty.js -g || error "failed npm install dependencies"

run_step sudo pip install \
  future \
  pynmea2 \
  grequests \
  bluerobotics-ping \
  || error "failed pip install dependencies"

run_step sudo pip3 install future || error "failed pip3 install dependencies"

# clone bluerobotics companion repository
run_step git clone --depth 1 -b $GIT_BRANCH https://github.com/$GIT_REPO $COMPANION_DIR || error "failed git clone"

run_step cd $COMPANION_DIR

run_step git submodule update --init --recursive || "error failed submodule update"

run_step cd $COMPANION_DIR/submodules/mavlink/pymavlink
run_step python3 setup.py build || "error failed "
run_step sudo python3 setup.py install || "error failed "

run_step cd $COMPANION_DIR/submodules/MAVProxy
run_step python setup.py build
run_step sudo python setup.py install

run_step cd $COMPANION_DIR/br-webui
run_step export JOBS=4
run_step npm install

run_step $COMPANION_DIR/scripts/setup-raspbian.sh
run_step $COMPANION_DIR/scripts/setup-system-files.sh

# run rpi update
run_step sudo rpi-update
