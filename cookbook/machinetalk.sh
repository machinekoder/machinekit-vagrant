#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
USERHOME=/home/vagrant

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if [ $(query-package [protobuf-compiler]) -eq 1 ]; then
    echo "Qt dependencies already installed"
else
    apt-get install -y --force-yes pkg-config python-protobuf \
            libprotobuf-dev protobuf-compiler python-zmq libzmq3-dev
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

if [ -e $USERHOME/repos/machinetalk-protobuf ]; then
    echo "Updating machinetalk-protobuf"
    cd $USERHOME/repos/machinetalk-protobuf
    git pull --rebase origin master
    make
    make install
    cd python
    python setup.py build
    python setup.py install
    cd ..
    chown -R vagrant .
else
    echo "Cloning machinetalk-protobuf"
    sudo apt-get install python-setuptools
    cd $USERHOME/repos
    git clone https://github.com/machinekit/machinetalk-protobuf
    chown -R vagrant machinetalk-protobuf
    cd machinetalk-protobuf
    make
    make install
    cd python
    python setup.py build
    python setup.py install
    cd ..
    chown -R vagrant .
fi

if [ -e $USERHOME/repos/pymachinetalk ]; then
    echo "Updating pymachinetalk"
    cd $USERHOME/repos/pymachinetalk
    git pull --rebase origin master
    python setup.py build
    python setup.py install
    chown -R vagrant .
else
    echo "Cloning pymachinetalk"
    cd $USERHOME/repos
    git clone https://github.com/strahlex/pymachinetalk
    chown -R vagrant pymachinetalk
    cd pymachinetalk
    python setup.py build
    python setup.py install
    chown -R vagrant .
fi
