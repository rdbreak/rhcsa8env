VAGRANTFILE_API_VERSION = "2"
VAGRANT_DISABLE_VBOXSYMLINKCREATE = "1"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Use same SSH key for each machine
config.ssh.insert_key = false
config.vm.box_check_update = false
config.vm.define "ipa" do |ipa|
  ipa.vm.box = "centos/7"
  ipa.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  ipa.vm.network "forwarded_port", guest: 80, host: 8081
  ipa.vm.network "forwarded_port", guest: 443, host: 8445
  ipa.vm.hostname = "ipa.example.com"
  ipa.vm.network "private_network", ip: "192.168.55.5"
  ipa.vm.provider :virtualbox do |ipa|
    ipa.customize ['modifyvm', :id,'--memory', '3072']
    end
  ipa.vm.provision "ansible" do |ansible|
    ansible.playbook = 'playbooks/ipa.yml'
  end
end
  
config.vm.define "system" do |system|
  system.vm.box = "puppetlabs/centos-7.0-64-nocm"
  system.vm.network "forwarded_port", guest: 80, host: 8082
  system.vm.network "forwarded_port", guest: 443, host: 8450
  system.vm.hostname = "system1.example.com"
  system.vm.network "private_network", ip: "192.168.55.6"
  system.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"

  system.vm.provider :virtualbox do |system|
    system.customize ['modifyvm', :id,'--memory', '1024']
    end
  system.vm.provision "ansible" do |ansible|
    ansible.playbook = 'playbooks/system.yml'
  end
end
end
