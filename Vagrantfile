# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "trusty-docker"
  config.vm.box_url = "https://github.com/jose-lpa/packer-ubuntu_14.04/releases/download/v2.0/ubuntu-14.04.box"
  config.vm.hostname = "docker-build"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
end
