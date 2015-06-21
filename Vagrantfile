# -*- mode: ruby -*-
# vi: set ft=ruby :

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

  config.vm.synced_folder '.', '/home/vagrant/docker-zabbix-proxy'

  config.vm.provision 'docker' do |d|
    d.build_image '/home/vagrant/docker-zabbix-proxy',
                  args: '-t nbarnum/zabbix-proxy'

    d.run 'nbarnum/zabbix-proxy',
          args: '--name zabbix-proxy',
          cmd: '-z 127.0.0.1 -s docker-proxy -m run'
  end
end
