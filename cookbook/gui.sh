#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
USERHOME=/home/vagrant

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

if type -P startlxde &>/dev/null; then
    echo "GUI is already installed";
else
    echo "Install minimal GUI"
    apt-get install -y lxde-core lightdm iceweasel synaptic
fi

if grep "autologin-user=vagrant" /etc/lightdm/lightdm.conf &>/dev/null; then
    echo "Autologin already enabled"
else
    echo "Enable autologin"
    printf "[SeatDefaults]\n" >> /etc/lightdm/lightdm.conf
    printf "autologin-user=vagrant\n" >> /etc/lightdm/lightdm.conf
fi

if grep "^autologin-user-timeout=0" /etc/lightdm/lightdm.conf &>/dev/null; then
    echo "Autologin timeout already defined"
else
    echo "Define autologin"
    printf "autologin-user-timeout=0\n" >> /etc/lightdm/lightdm.conf
fi

if [ $(query-package xscreensaver) -eq 0 ]; then
    echo "Screensaver already disabled"
else
    echo "Removing xscreensaver"
    apt-get remove -y xscreensaver
    apt-get autoremove -y
fi

if [ $(query-package leafpad) -eq 1 ]; then
    echo "Leafpad already installed"
else
    apt-get install -y leafpad
fi

if [ $(query-package tilda) -eq 1 ]; then
    echo "Tilda already installed"
else
    apt-get install -y tilda
fi

if grep "^[Desktop Entry]" $USERHOME/.config/autostart/tilda.desktop &>/dev/null; then
    echo "Tilda autostart already set-up"
else
    echo "Define Tilda autologin"
    mkdir -p $USERHOME/.config/autostart/
    printf "[Desktop Entry]\nType=Application\nExec=tilda\n" >> $USERHOME/.config/autostart/tilda.desktop
fi

if grep "^XKBLAYOUT=\"us,gb,de,fr,es,ru\"" /etc/default/keyboard &>/dev/null; then
    echo "Keyboard layouts already set-up"
else
    echo "Setting up keyboard layouts"
    sed -i '/XKBLAYOUT/c\XKBLAYOUT="us,gb,de,fr,es,ru"' /etc/default/keyboard
    udevadm trigger --subsystem-match=input --action=change
    mkdir -p $USERHOME/.config/autostart/
    printf "[Desktop Entry]\nType=Application\nExec=setxkbmap\n" >> $USERHOME/.config/autostart/setxkbmap.desktop
fi

if [ -e $USERHOME/.config/lxpanel/LXDE/panels/panel ]; then
    echo "LXDE panel already prepared"
else
    echo "Preparing LXDE panel"
    mkdir -p $USERHOME/.config/lxpanel/LXDE/panels/
    chown -R vagrant $USERHOME/.config
    cp $USERHOME/provision/files/panel $USERHOME/.config/lxpanel/LXDE/panels/
fi

if [ -e $USERHOME/Pictures/machinekit-tile.png ]; then
    echo "Machinekit wallpaper already installed"
else
    echo "Installing Machinekit wallpaper"
    mkdir -p $USERHOME/Pictures/
    cp $USERHOME/provision/files/machinekit-tile.png $USERHOME/Pictures/
    mkdir -p $USERHOME/.config/pcmanfm/LXDE/
    chown -R vagrant $USERHOME/.config
    cp $USERHOME/provision/files/desktop-items-0.conf $USERHOME/.config/pcmanfm/LXDE/
fi
