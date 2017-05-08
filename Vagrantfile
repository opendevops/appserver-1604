# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # VAGRANT BOX
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  # Official Ubuntu 16.04 LTS (280k+ downloads)
  # user = ubuntu
  # config.vm.box = "ubuntu/xenial64"

  # bento: from Chef(?) (120k+ downloads)
  # suggested here: https://github.com/mitchellh/vagrant/issues/7389#issuecomment-223802140
  config.vm.box = "bento/ubuntu-16.04"

  # boxcutter: user = vagrant (26k+ downloads)
  # also installs ruby
  # config.vm.box = "boxcutter/ubuntu1604"

  # puppetlabs: 5k+ downloads
  # config.vm.box = "puppetlabs/ubuntu-16.04-64-puppet"

  # geerlingguy user = vagrant (110k+ downloads)
  # also installs ruby
  # config.vm.box = "geerlingguy/ubuntu1604"


  # PROVISION
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y puppet
  SHELL

  #config.vm.provision "shell", path: "www/scripts/local-before-puppet.sh"

  # Enable the Puppet provisioner, with will look in manifests
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'www/puppet/manifests'
    puppet.manifest_file = 'local.pp'
    puppet.module_path = 'www/puppet/modules'
  end


  #config.vm.provision "shell", path: "www/scripts/local-post-puppet.sh"


  # NETWORK IP ADDRESS
  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", :ip => '192.168.56.99'

  # Provider-specific configuration so you can fine-tune various backing providers for Vagrant.
  config.vm.provider 'vmware_desktop' do |v|
    v.name = 'appserver-1604'
    v.customize ['modifyvm', :id, '--cpuexecutioncap', '70']
    v.memory = 2048
    v.cpus = 2
  end
  # see http://stackoverflow.com/a/23887366
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # config.vm.synced_folder "www", "/var/www", type: "nfs"
  config.vm.synced_folder ".", "/vagrant", :nfs => true, :mount_options => ['actimeo=2']

  # avoid "stdin: is not a tty" message. See http://goo.gl/Zjs8VT
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

end
