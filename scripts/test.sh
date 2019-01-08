#!/usr/bin/env bash

GIT_BRANCH="setup"

error() {
    echo -e "ERROR: $*" >&2
    exit 1
}

run_step() {
  echo -e ""
  echo -e ""
  echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo -e "RUN STEP: $@"
  echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  "$@" || error "failed RUN STEP $@ with code $?"
  echo -e "completed RUN STEP $@ with code $?"
}

run_step echo hello

run_step echo "$GIT_BRANCH"
