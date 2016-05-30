#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if [ $(query-package virtualbox-guest-x11) -eq 1 ]; then
    echo "VirtualBox Guest Additions already installed"
else
    sudo sh -c \
    "echo 'deb http://debian.inode.at/debian jessie-backports main contrib non-free' > \
    /etc/apt/sources.list.d/backports.list"
    sudo apt-get update
    #sudo apt-get upgrade -y
    sudo apt-get install -y virtualbox-guest-utils virtualbox-guest-x11 virtualbox-guest-dkms
fi

