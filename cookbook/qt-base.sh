#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if [ $(query-package libxslt1.1) -eq 1 ]; then
    echo "Qt dependencies already installed"
else
    echo "Installing Qt dependencies"
    apt-get update
    apt-get install -y --force-yes build-essential gdb subversion dh-autoreconf libgl1-mesa-dev lynx pkg-config dovetail-automata-keyring python-protobuf libprotobuf-dev protobuf-compiler libnotify-bin libczmq-dev python-zmq libzmq3-dev libxslt1.1 git
fi
su -c "source /home/vagrant/provision/qt.sh" vagrant
