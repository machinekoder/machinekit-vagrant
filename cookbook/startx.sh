#!/usr/bin/env bash

if ps cax | grep lightdm > /dev/null; then
    echo "Desktop environment already running"
else
    echo "Starting desktop environment"
    sudo lightdm &
    echo "Cleanup folders"
    cd /home/vagrant/
    rm -r -f Documents
    rm -r -f Examples
    rm -r -f Extras
    rm -r -f Music
    rm -r -f Pictures
    rm -r -f Templates
    rm -r -f Videos
fi
