#!/usr/bin/env bash

if ps cax | grep lightdm > /dev/null; then
    echo "Desktop environment already running"
else
    echo "Starting desktop environment"
    sudo lightdm &
fi
