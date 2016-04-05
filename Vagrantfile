Vagrant.configure("2") do |config|

  # Add a host entry for this on your local system pointing at your chosen hostname
  ip='192.168.1.2'
  hostname='pm0.graphenic.com.au'

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "60"]
  end

  config.vm.network "private_network", ip: "#{ip}", nic_type: "virtio"

  config.vm.box = "debian/contrib-jessie64"
  config.vm.hostname = "#{hostname}"

   config.vm.provision "shell" do |shell|
     shell.inline = "wget http://apt.puppetlabs.com/puppetlabs-release-jessie.deb"
     shell.inline = "dpkg -i puppetlabs-release-jessie.deb"
     shell.inline = "apt-get update"
     shell.inline = "apt-get -y install puppet"
   end

  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.working_directory = "/vagrant"
    puppet.options = ""
  end

end
