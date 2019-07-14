VAGRANTFILE_API_VERSION = "2"
VAGRANT_DISABLE_VBOXSYMLINKCREATE = "1"
file_to_disk = './disk-0-0.vdi'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Use same SSH key for each machine
config.ssh.insert_key = false
config.vm.box_check_update = false
#config.vm.define "ipa" do |ipa|
#  ipa.vm.box = "generic/oracle8"
#  ipa.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
#  ipa.vm.provision :shell, :inline => "sudo yum install -y python2 python36 libselinux-devel", run: "always"
#  ipa.vm.provision :shell, :inline => "ln -s /usr/bin/python3.6 /usr/bin/python", run: "always"
##  ipa.vm.network "forwarded_port", guest: 80, host: 8090
##  ipa.vm.network "forwarded_port", guest: 443, host: 8460
#  ipa.vm.hostname = "ipa.example.com"
#  ipa.vm.network "private_network", ip: "192.168.55.10"
#  ipa.vm.provider :virtualbox do |ipa|
#    ipa.customize ['modifyvm', :id,'--memory', '3072']
#    end
#  ipa.vm.provision "ansible" do |ansible|
#    ansible.playbook = 'playbooks/ipa.yml'
#    ansible.version = "latest"
#  end
#end
  
config.vm.define "system" do |system|
  system.vm.box = "generic/oracle8"
#  system.vm.network "forwarded_port", guest: 80, host: 8090
#  system.vm.network "forwarded_port", guest: 443, host: 8451
  system.vm.hostname = "system.example.com"
  system.vm.network "private_network", ip: "192.168.55.5"
  system.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  system.vm.provision :shell, :inline => "sudo yum install -y python2 python36 libselinux-devel", run: "always"
  system.vm.provision :shell, :inline => "ln -s /usr/bin/python3.6 /usr/bin/python", run: "always"
  system.vm.provider "virtualbox" do |system|
    system.memory = "1024"

    if not File.exist?(file_to_disk)
      system.customize ['createhd', '--filename', file_to_disk, '--variant', 'Fixed', '--size', 10 * 1024]
    end
    system.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata', '--portcount', 1]
    system.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
  end
  
  config.vm.provision "shell", inline: <<-SHELL
  yes| sudo mkfs.ext4 /dev/sdb
  SHELL

#config.vm.define "test" do |test|
#  test.vm.box = "generic/oracle8"
##  test.vm.network "forwarded_port", guest: 80, host: 8090
##  test.vm.network "forwarded_port", guest: 443, host: 8451
#  test.vm.hostname = "test.example.com"
#  test.vm.network "private_network", ip: "192.168.55.6"
#  test.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo testctl restart sshd;", run: "always"
#  test.vm.provision :shell, :inline => "sudo yum install -y python2 python36 libselinux-devel", run: "always"
#  test.vm.provision :shell, :inline => "ln -s /usr/bin/python3.6 /usr/bin/python", run: "always"
#  test.vm.provider "virtualbox" do |test|
#    test.memory = "1024"
#
  system.vm.provision "ansible" do |ansible|
    ansible.version = "latest"
    ansible.limit = "all"
    ansible.playbook = 'playbooks/system.yml'
  end
end
end



