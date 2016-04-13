# Machinekit Vagrant
Vagrant config for [Machinekit](http://machinekit.io), [QtQuickVcp](https://github.com/strahlex/QtQuickVcp) and the [Machinekit SDK](https://github.com/strahlex/MachinekitSDK)

## Getting Started
This gettings started will lead you trough the installation process.

### Clone Git repository
If you have Git installed on your computer clone the Git repository to
your computer:

    git clone https://github.com/strahlex/machinekit-vagrant.git

In case you **don't have Git installed** and you do not bother installing
you can also just **download** the Git repository as
[**Zip file**](https://github.com/strahlex/machinekit-vagrant/archive/master.zip).

### Install Vagrant
Next you need to download and install
[Vagrant](https://www.vagrantup.com/downloads.html). Just follow the
steps in the installer.

### Start Vagrant
When installing Vagrant is completed start up a terminal on your
computer. On Windows either type `cmd` in the start menu or
**Shift-Right-Click (Open Command Window here...)** in your desired
folder. If you are not in the folder where you cloned or extracted the
contents of the Git repository please navigate there using the `cd`
command (`cd /my/cool/folder`).

Now continute by typing `vagrant up` in the terminal. You may be asked
to install VirtualBox at some point. Just agree and lean back.

Wait for the VM installation to complete.

### Watch the tutorial
Once everything has completed (take a look at the terminal) you can
continue wiht the tutorial:

[![Building Qt5 UIs with the MachinekitSDK](http://img.youtube.com/vi/IdB5769JtqI/0.jpg)</br>Building Qt5 UIs with the MachinekitSDK](https://www.youtube.com/watch?v=IdB5769JtqI&feature=youtu.be)

## Troubleshooting
Common problems and solutions.

### Windows - VBoxManage.exe: error: Failed to create the host-only adapter
Problem is either related to missing Windows UAC rights or an old
version of VirtualBox on Windows 10. Try the following to solve the
problem:

- Upgrade VirtualBox to the latest version

- Or try following
 * Open VirtuaBox
 * Go to File->Preferences->Network->Host-only Networks
 * Remove the existing network adapter
 * Create a new adapter with the default settings
 * Restart Vagrant

### Windows - VirtualBox crashing
If VirtualBox keeps crashing when starting Vagrant it may be a problem
with VirtualBox itself. Try to start VirtualBox manually and boot up
the VM. If there is a VT-x problem it may be that your computer does
not support hardware virtualiziaton. However, in some cases it is just
related to the Hyper-V being enabled. To disable Hyper-V take a look
at
[this tutorial](http://www.eightforums.com/tutorials/42041-hyper-v-enable-disable-windows-8-a.html)

### Desktop does not appear
This problem can be related to the Vagrant VirtualBox GuestAdditions
plugin. If you are not sure if you have it installed and you do not
care to keep it installed please delete your Vagrant folders. These
are `.vagrant` in the `machinekit-vagrant` directory and `.vagrant.d` in
`C:\Users\<yourname>\`.

### 3D Acceleration is not working
Well, thats embarrasing. This is a result of a
[VirtualBox Bug](https://www.virtualbox.org/ticket/12746) with 64bit
Linux guests and will hopefully get fixed in the future. For now just
don't enable 3D acceleration and everything should be fine.
