Vagrant.configure("2") do |config|
   config.vm.box = "precise64"
   config.vm.box_url = "http://files.vagrantup.com/precise64.box"
   config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--cpus", 4]
     vb.customize ["modifyvm", :id, "--memory", 2048]
     # This next line has to be done because of a
     # long standing annoying virtualbox dhcp bug
     # https://www.virtualbox.org/ticket/10864
     # https://gist.github.com/mitchellh/1277049
     vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
   end
   config.vm.provision :shell, path: "vagrant_script.sh"
   config.vm.network :forwarded_port, :host => 8080, :guest => 80
end