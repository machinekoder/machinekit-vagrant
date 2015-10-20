#!/usr/bin/env bash
mkdir -p /home/vagrant/provision/
cd /home/vagrant/shared/cookbook/
cp qt.sh /home/vagrant/provision/.
cp QtCreator.ini /home/vagrant/provision/.
sudo chown vagrant /home/vagrant/provision/
