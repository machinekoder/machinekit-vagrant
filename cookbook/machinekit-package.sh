#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if [ $(query-package machinekit-posix) -eq 1 ]; then
    echo "Machinekit already installed"
else
    echo "Adding Machinekit repository"
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 43DDF224
    sudo sh -c \
    "echo 'deb http://deb.machinekit.io/debian jessie main' > \
    /etc/apt/sources.list.d/machinekit.list"
    sudo apt-get update
fi
#sudo apt-get install -y machinekit-posix avahi-daemon machinekit-dev git
#machinekit-dev deprecated: https://groups.google.com/forum/#!searchin/machinekit/xenomai|sort:date/machinekit/8FNH1CixtKU/OwZCmvSkAAAJ
sudo apt-get install -y machinekit-posix avahi-daemon git
