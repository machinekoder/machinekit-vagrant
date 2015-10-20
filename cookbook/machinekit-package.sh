#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if [ $(query-package machinekit-posix) -eq 1 ]; then
    echo "Machinekit already installed"
    #sudo apt-get update
    #sudo apt-get upgrade -y
else
    sudo sh -c \
         "echo 'deb http://deb.dovetail-automata.com jessie main' > \
    /etc/apt/sources.list.d/machinekit.list;"
    sudo apt-get update
    sudo apt-get install -y --force-yes dovetail-automata-keyring
    sudo apt-get update
    #sudo apt-get upgrade -y
    sudo apt-get install -y machinekit-posix avahi-daemon
fi
