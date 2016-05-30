#!/usr/bin/evn bash
if [ $(query-package machinekit-dev) -eq 1 ]; then
    echo "Installing Machinekit development packages"
    sudo apt-get install -y machinekit-dev
else
    echo "Machinekit development packages already installed"
fi
