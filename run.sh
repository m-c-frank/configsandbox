#!/bin/sh
# Exit on error
set -e
# Navigate to the directory containing Vagrantfile
cd "$(dirname "$0")"
# Initialize Vagrant with QEMU/KVM provider if Vagrantfile does not exist
if [ ! -f Vagrantfile ]; then
    vagrant init generic/arch
    sed -i '/config.vm.box = "generic\/arch"/a \ \ config.vm.provider :libvirt do |libvirt|\n    libvirt.graphics_type = "spice"\n    libvirt.video_type = "qxl"\n  end' Vagrantfile
fi
# Start the virtual machine
vagrant up --provider=libvirt
# SSH into the virtual machine
vagrant ssh
