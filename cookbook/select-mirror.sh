#!/usr/bin/env bash

if [ -e /etc/mirror-selected ]; then
    echo "Optimal mirror has already been selected."
    sudo apt-get update
else
    echo "Selecting optimal mirror"
    sudo apt-get update
    sudo apt-get install -y netselect-apt
    sudo netselect-apt
    sudo mv sources.list /etc/apt/sources.list
    sudo apt-get clean
    sudo apt-get update
    echo "done" > /etc/mirror-selected
fi
