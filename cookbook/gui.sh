#!/usr/bin/env bash

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if type -P startlxde &>/dev/null; then
    echo "GUI is already installed";
else
    echo "Install minimal GUI"
    sudo apt-get update
    sudo apt-get install -y lxde-core lightdm iceweasel synaptic
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

if [ $(query-package leafpad) -eq 1 ]; then
    echo "Leafpad already installed"
else
    sudo apt-get install -y leafpad
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

if grep "^XKBLAYOUT=\"us,gb,de,fr,es,ru\"" /etc/default/keyboard &>/dev/null; then
    echo "Keyboard layouts already set-up"
else
    echo "Setting up keyboard layouts"
    sudo sed -i '/XKBLAYOUT/c\XKBLAYOUT="us,gb,de,fr,es,ru"' /etc/default/keyboard
    udevadm trigger --subsystem-match=input --action=change
fi

if [ -e /home/vagrant/.config/lxpanel/LXDE/panels/panel ]; then
    echo "LXDE panel already prepared"
else
    echo "Preparing LXDE panel"
    mkdir -p /home/vagrant/.config/lxpanel/LXDE/panels/
    chown -R vagrant /home/vagrant/.config
    cp /home/vagrant/provision/files/panel /home/vagrant/.config/lxpanel/LXDE/panels/
fi

if [ -e /home/vagrant/Pictures/machinekit-tile.png ]; then
    echo "Machinekit wallpaper already installed"
else
    echo "Installing Machinekit wallpaper"
    cp /home/vagrant/provision/files/machinekit-tile.png /home/vagrant/Pictures/
    mkdir -p /home/vagrant/.config/pcmanfm/LXDE/
    chown -R vagrant /home/vagrant/.config
    cp /home/vagrant/provision/files/desktop-items-0.conf /home/vagrant/.config/pcmanfm/LXDE/
fi
