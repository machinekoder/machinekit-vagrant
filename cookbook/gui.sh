#!/usr/bin/env bash

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if type -P startlxde &>/dev/null; then
    echo "GUI is already installed";
else
    echo "Install minimal GUI"
    sudo apt-get install -y lxde-core lightdm
fi

if grep "autologin-user=vagrant" /etc/lightdm/lightdm.conf &>/dev/null; then
    echo "Autologin already enabled"
else
    echo "Enable autologin"
    sudo printf "[SeatDefaults]\n" >> /etc/lightdm/lightdm.conf
    sudo printf "autologin-user=vagrant\n" >> /etc/lightdm/lightdm.conf
fi

if grep "^autologin-user-timeout=0" /etc/lightdm/lightdm.conf &>/dev/null; then
    echo "Autologin timeout already defined"
else
    echo "Define autologin"
    sudo printf "autologin-user-timeout=0\n" >> /etc/lightdm/lightdm.conf
fi

if [ $(query-package xscreensaver) -eq 0 ]; then
    echo "Screensaver already disabled"
else
    echo "Removing xscreensaver"
    sudo apt-get remove -y xscreensaver
    sudo apt-get autoremove -y
fi

if [ $(query-package tilda) -eq 1 ]; then
    echo "Tilda already installed"
else
    sudo apt-get install -y tilda
fi

if grep "^[Desktop Entry]" ~/.config/autostart/tilda.desktop &>/dev/null; then
    echo "Tilda autostart already set-up"
else
    echo "Define Tilda autologin"
    mkdir -p ~/.config/autostart/
    sudo printf "[Desktop Entry]\nType=Application\nExec=tilda\n" >> ~/.config/autostart/tilda.desktop
fi

if grep "^XKBLAYOUT=\"us,de,fr,ua,ru\"" /etc/default/keyboard &>/dev/null; then
    echo "Keyboard layouts already set-up"
else
    echo "Setting up keyboard layouts"
    sudo sed -i '/XKBLAYOUT/c\XKBLAYOUT="us,de,fr,ua,ru"' /etc/default/keyboard
    udevadm trigger --subsystem-match=input --action=change
fi

