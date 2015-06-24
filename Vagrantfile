# -*- mode: ruby -*-
# vi: set ft=ruby :

CONTAINER_NAME = 'zabbix-proxy'
ZABBIX_SERVER = '10.1.1.10'

Vagrant.configure(2) do |config|
  # config.vm.box = 'ubuntu/trusty64'
  # This box has docker preinstalled. Something like ubuntu/trusty64 can be used,
  # but the docker provisioning will take longer since docker must be installed.
  config.vm.box = 'trusty-docker'
  config.vm.box_url = 'https://github.com/jose-lpa/packer-ubuntu_14.04/releases/download/v2.0/ubuntu-14.04.box'

  config.vm.hostname = 'docker-build'

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = '1024'
  end

  config.vm.provision 'docker' do |d|
    d.build_image '/vagrant',
                  args: "-t nbarnum/#{CONTAINER_NAME}"

    d.run "nbarnum/#{CONTAINER_NAME}",
          args: "--name #{CONTAINER_NAME}",
          cmd: "-z #{ZABBIX_SERVER} -s #{CONTAINER_NAME}"
  end
end
