#!/usr/bin/env bash
VBOX_VERSION=`ls /opt/`
if [[ "$VBOX_VERSION" == *"VBoxGuestAdditions-5.0.6"* ]]; then
    echo "VBox Guest Additions up to date"
else
    echo "Updating VBox Guest Additions"
export DEBIAN_FRONTEND=noninteractive
apt-get install -y build-essential module-assistant
m-a prepare -i
cd /opt
echo "Downloading VBoxGuestAdditions"
wget -c http://download.virtualbox.org/virtualbox/5.0.6/VBoxGuestAdditions_5.0.6.iso -O VBoxGuestAdditions.iso -nv
mount VBoxGuestAdditions.iso -o loop /mnt
cd /mnt
sh VBoxLinuxAdditions.run
cd /opt
rm *.iso
fi
