#!/usr/bin/env bash
USERHOME=/home/vagrant

if [ -e $USERHOME/repos/machinetalk-protobuf ]; then
    echo "Updating machinetalk-protobuf"
    cd $USERHOME/repos/machinetalk-protobuf
    git pull --rebase origin/python-setup
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
    git clone https://github.com/strahlex/machinetalk-protobuf
    chown -R vagrant machinetalk-protobuf
    cd machinetalk-protobuf
    git checkout python-setup
    make
    make install
    cd python
    python setup.py build
    python setup.py install
    cd ..
    chown -R vagrant .
fi

if [ -e $USERHOME/repos/pymachinetalk]; then
    echo "Updating pymachinetalk"
    cd $USERHOME/repos/pymachinetalk
    git pull --rebase origin/master
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
