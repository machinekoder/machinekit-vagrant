# machinekit-vagrant
Vagrant config for Machinekit

## Troubleshooting

### VBoxManage.exe: error: Failed to create the host-only adapter
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
