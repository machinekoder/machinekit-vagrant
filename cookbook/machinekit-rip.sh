#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 43DDF224
sudo sh -c \
     "echo 'deb http://deb.machinekit.io/debian jessie main' > \
    /etc/apt/sources.list.d/machinekit.list"
sudo apt-get update

sudo apt-get install -y libczmq-dev python-zmq libjansson-dev \
    libwebsockets-dev libxenomai-dev lsb-release cython bwidget

sudo apt-get install -y git dpkg-dev
sudo apt-get install -y --no-install-recommends devscripts equivs
mkdir -p /home/vagrant/repos
cd /home/vagrant/repos
git clone https://github.com/machinekit/machinekit.git
cd machinekit
debian/configure -px
mk-build-deps -ir -t "apt-get --no-install-recommends -y"
cd src
./autogen.sh
./configure
make
make setuid
chown -R vagrant /home/vagrant/repos

# install additional packages
# add rip-environment to bashrc
# set REMOTE=1 in machinekit.ini
# setuid?
