#!/usr/bin/env bash
mkdir -p /home/vagrant/provision/
cd /home/vagrant/shared/cookbook/
cp qt.sh /home/vagrant/provision/.
cp -r files /home/vagrant/provision/
sudo chown -R vagrant /home/vagrant/provision/
