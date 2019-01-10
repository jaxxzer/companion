#!/usr/bin/env bash

mkdir tmp || exit 1
pushd tmp
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/install-dependencies.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/setup-system-files.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/setup-raspbian.sh
wget https://raw.githubusercontent.com/jaxxzer/companion/setup/scripts/bash-helpers.sh
ls
chmod +x *.sh
./install-dependencies.sh && \
./setup-raspbian.sh && \
./setup-system-files.sh
popd
rm -rf tmp
