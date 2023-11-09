# ConfigSandbox

This README includes instructions and necessary scripts to set up a Vagrant environment with QEMU/KVM on Artix Linux with runit using a single command.

## Quickstart

Run the following command in your terminal to set up the environment:

```sh
bash <(curl -s https://github.com/m-c-frank/configsandbox/raw/main/setup_all.sh)
```

## Repository Directory Tree

```
configsandbox/
├── README.md
├── Vagrantfile
├── install.sh
├── run.sh
└── setup_all.sh
```

## ./configsandbox/install.sh

```sh
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
```

## ./configsandbox/run.sh

```sh
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
```

## ./configsandbox/setup_all.sh

```sh
#!/bin/sh
# Exit on error
set -e
# Define the repository URL
REPO_URL="https://github.com/m-c-frank/configsandbox"
# Clone the repository
git clone "$REPO_URL" configsandbox
# Change into the directory
cd configsandbox
# Run the installation script
chmod +x install.sh && ./install.sh
# Run the script to start the environment
chmod +x run.sh && ./run.sh
```

## ./configsandbox/Vagrantfile

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"
  config.vm.provider :libvirt do |libvirt|
    libvirt.graphics_type = "spice"
    libvirt.video_type = "qxl"
  end
end
```

## Note

- Ensure that virtualization is enabled in your BIOS/UEFI settings.
- You may need to log out and log back in or reboot for the group changes to take effect.
- The `install.sh` script will prompt for a reboot. After rebooting, you will need to manually run `run.sh` to start the Vagrant environment.
