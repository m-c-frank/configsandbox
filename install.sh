#!/bin/sh
# Exit on error
set -e
# Ensure the system is up to date
sudo pacman -Syu
# Install necessary packages
sudo pacman -S --needed vagrant qemu virt-manager dnsmasq virt-viewer bridge-utils openbsd-netcat
# Enable and start the required services
sudo ln -s /etc/runit/sv/libvirtd /run/runit/service/
sudo ln -s /etc/runit/sv/virtlogd /run/runit/service/
sudo ln -s /etc/runit/sv/virtlockd /run/runit/service/
# Add user to necessary groups
sudo usermod -aG libvirt,kvm $(whoami)
# Install Vagrant plugin for libvirt
vagrant plugin install vagrant-libvirt
# Reboot to apply group changes and ensure services are started
echo "Please reboot your computer before running 'run.sh'."
