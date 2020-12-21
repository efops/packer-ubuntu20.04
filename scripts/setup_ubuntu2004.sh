#!/bin/bash

apt-get install -f -y python net-tools curl cloud-init python3-pip

# Install VMWare Guestinfo Cloud-init source, used by rancher
curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -

# Reset Machine-ID
# http://manpages.ubuntu.com/manpages/bionic/man5/machine-id.5.html
# This is the equivalent of the SID in Windows
# Netplan also uses this as DHCP Identifier, causing multiple VMs from the same Image
# to get the same IP Address
rm -f /etc/machine-id

# Reset Cloud-init state
# systemctl stop cloud-init
# rm -rf /var/lib/cloud/
cloud-init clean -s -l
