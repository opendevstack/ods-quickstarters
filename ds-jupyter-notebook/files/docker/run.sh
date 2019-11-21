#!/bin/bash

set -e

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# create work directory
mkdir -p /opt/app-root/src/work

# set the home directories to a folder with read/write access
export XDG_DATA_HOME=/opt/app-root/src
export HOME=/opt/app-root/src

# link jupyter configs
export JUPYTER_CONFIG_DIR=/opt/app-root/src/.jupyter
export JUPYTER_PATH=/opt/app-root/src/work/.jupyter
export JUPYTER_RUNTIME_DIR=/opt/app-root/src/work/.jupyter/runtime

exec $@
