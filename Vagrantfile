Vagrant.configure("2") do |config|
  config.vm.box = "voidlinux/glibc64"
  config.vm.provider :libvirt do |libvirt|
    libvirt.graphics_type = "spice"
    libvirt.video_type = "qxl"
  end
end
