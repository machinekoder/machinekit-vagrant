#!/usr/bin/env bash

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if [ $(query-package machinekit-posix) -eq 1 ]; then
    echo "Machinekit already installed"
    sudo apt-get update
    sudo apt-get upgrade -y
else
    export DEBIAN_FRONTEND=noninteractive
sudo sh -c \
    "echo 'deb http://deb.dovetail-automata.com jessie main' > \
    /etc/apt/sources.list.d/machinekit.list;"
sudo apt-get update
sudo apt-get install -y --force-yes dovetail-automata-keyring
sudo apt-get update
sudo apt-get install -y --force-yes build-essential gdb subversion dh-autoreconf libgl1-mesa-dev lynx pkg-config dovetail-automata-keyring python-protobuf libprotobuf-dev protobuf-compiler libnotify-bin libczmq-dev python-zmq libzmq-dev
sudo apt-get install -y machinekit-posix
fi
