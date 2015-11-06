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
    sudo apt-get install -y machinekit-posix avahi-daemon machinekit-dev git
fi

if [ -e ./repos/mkwrapper-sim ]; then
    echo "Mkwrapper-sim already installed"
else
    echo "Cloning mkwrapper-sim"
    cd /home/vagrant
    mkdir -p repos
    chown -R vagrant repos
    cd repos
    git clone https://github.com/strahlex/mkwrapper-sim
    chown -R vagrant mkwrapper-sim
fi

if [ -e ./repos/anddemo ]; then
    echo "anddemo already installed"
else
    echo "Cloning anddemo"
    cd /home/vagrant/repos
    git clone https://github.com/strahlex/anddemo
    chown -R vagrant anddemo
fi

if grep -Fxq "REMOTE=1" /etc/linuxcnc/machinekit.ini; then
    echo "Machinetalk remote already enabled"
else
    echo "Enabling Machinetalk remote"
    apt-get install -y uuid-runtime
    sed -i 's/REMOTE=.*/REMOTE=1/' /etc/linuxcnc/machinekit.ini
    UUID=`uuidgen`
    sed -i "s/MKUUID=.*/MKUUID=$UUID/" /etc/linuxcnc/machinekit.ini
fi
