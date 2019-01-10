#!/usr/bin/env bash

export COMPANION_DIR=$HOME/companion

GIT_USER=jaxxzer
GIT_BRANCH=setup
BASE_URL=https://raw.githubusercontent.com/$GIT_USER/companion/$GIT_BRANCH/scripts

mkdir tmp || { echo "failed to make temporary directory" >&2 && exit 1; }
pushd tmp

wget $BASE_URL/bash-helpers.sh || { echo "failed to download $BASE_URL/bash-helpers.sh" >&2 && exit 1; }

# source helpers
. ./bash-helpers.sh

# get scripts
run_step wget $BASE_URL/install-dependencies.sh
run_step wget $BASE_URL/setup-system-files.sh
run_step wget $BASE_URL/setup-raspbian.sh

run_step chmod +x *.sh

# install dependencies from apt, pip etc
run_step ./install-dependencies.sh

run_step pwd
run_step ls

# setup raspbian/raspberry-pi specific files
run_step ./setup-raspbian.sh

# setup system and user configuration files
run_step ./setup-system-files.sh

# clean up, remove files
popd
rm -rf tmp
