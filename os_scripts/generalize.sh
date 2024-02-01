#!/bin/sh
#
# Runs in the VM to generalize it.
#
#
# Update and clean packages
apt update && apt -y upgrade && apt -y autoremove && apt clean
# 
# Delete user
userdel -r james
#
# Clear host name
truncate -s0 /etc/hostname
hostnamectl set-hostname localhost
#
# Clear Netplan configs
rm /etc/netplan/*
#
# Clear machine ID
truncate -s0 /etc/machine-id
rm -v /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
#
# Clear cloud init (May not be needed for KVM)
cloud-init clean
#
# Delete logs
rm -v /var/log/*
#
# Clear shell history
truncate -s0 ~/.bash_history
history -c
#
# Diable password for root
passwd -dl root
#
shutdown 0 0 




