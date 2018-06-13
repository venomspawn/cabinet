# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'develop', primary: true do |dev|
    dev.vm.provider 'virtualbox' do |machine|
      machine.memory = 1024
      machine.cpus   = 2
    end

    dev.vm.box      = 'ubuntu/trusty64'
    dev.vm.hostname = 'cab'

    dev.vm.network 'private_network', ip: '192.168.33.44'
    dev.vm.network 'forwarded_port', guest: 8044, host: 8044

    dev.ssh.forward_agent = true
    dev.vm.post_up_message =
      'Machine is up and ready to development. Use `vagrant ssh` to enter.'

    dev.vm.provision :shell, keep_color: true, inline: <<-INSTALL
      echo 'StrictHostKeyChecking no' > ~/.ssh/config
      echo 'UserKnownHostsFile=/dev/null no' >> ~/.ssh/config
      sudo apt-get install git -y
    INSTALL

    dev.vm.provision :ansible_local do |ansible|
      ansible.provisioning_path = '/vagrant/cm/provisioning'
      ansible.playbook          = 'main.yml'
      ansible.inventory_path    = 'inventory.ini'
      ansible.verbose           = true
      ansible.limit             = 'local'
      ansible.galaxy_roles_path = 'roles'
      ansible.galaxy_role_file  = 'requirements.yml'
    end
  end
end
