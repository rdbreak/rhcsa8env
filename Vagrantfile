VAGRANTFILE_API_VERSION = "2"
VAGRANT_DISABLE_VBOXSYMLINKCREATE = "1"
file_to_disk1 = './disk-0-1.vdi'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Use same SSH key for each machine
config.ssh.insert_key = false
config.vm.box_check_update = false
config.vm.define "system" do |system|
  system.vm.box = "generic/oracle8"
#  system.vm.hostname = "system.eight.example.com"
  system.vm.network "private_network", ip: "192.168.55.151"
  system.vm.network "private_network", ip: "192.168.55.175"
  system.vm.network "private_network", ip: "192.168.55.176"
  system.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  system.vm.provision :shell, :inline => " sudo systemctl stop packagekit; sudo systemctl mask packagekit", run: "always"
  system.vm.provision :shell, :inline => "sudo yum install -y @idm:DL1; sudo dnf -y install httpd python36 python2 python2-pip python3-pip python2-setuptools python3-setuptools python2-devel python36-devel python3-cryptography;", run: "always"
  system.vm.provision :shell, :inline => "dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y; sudo yum install -y sshpass httpd vsftpd createrepo pki-ca", run: "always"
  system.vm.synced_folder ".", "/vagrant"
  system.vm.provider "virtualbox" do |system|
    system.memory = "1024"

    if not File.exist?(file_to_disk1)
      system.customize ['createhd', '--filename', file_to_disk1, '--variant', 'Fixed', '--size', 10 * 1024]
    end
    system.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata', '--portcount', 2]
    system.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk1]
  end
  
    system.vm.provision "shell", inline: <<-SHELL
    yes| sudo mkfs.ext4 /dev/sdb
    SHELL
  system.vm.provision :shell, :inline => "pip3 install ansible", run: "always"
#  system.vm.provision "ansible_local" do |ansible|
#    ansible.playbook = '/vagrant/playbooks/system.yml'
#    ansible.install = false
#    ansible.compatibility_mode = "2.0"
#    ansible.verbose = true
  system.vm.provision :shell, :inline => "reboot", run: "always"
#  end
end
config.vm.define "ipa" do |ipa|
  ipa.vm.box = "generic/oracle8"
  ipa.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  ipa.vm.provision :shell, :inline => "sudo yum install -y createrepo @idm:DL1; sudo dnf -y install httpd python36 python2 python2-pip python3-pip python2-setuptools python3-setuptools python2-devel python36-devel python3-cryptography;", run: "always"
  ipa.vm.provision :shell, :inline => "dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y; sudo yum install -y sshpass httpd vsftpd createrepo pki-ca", run: "always"
  ipa.vm.provision :shell, :inline => "sudo mkdir -p /var/www/html/rpms; ", run: "always"
  ipa.vm.synced_folder ".", "/vagrant"
#  ipa.vm.hostname = "ipa.eight.example.com"
  ipa.vm.network "private_network", ip: "192.168.55.150"
  ipa.vm.provider :virtualbox do |ipa|
    ipa.customize ['modifyvm', :id,'--memory', '2048']
    end
  ipa.vm.provision :shell, :inline => "pip3 install ansible", run: "always"
#  ipa.vm.provision "ansible_local" do |ansible|
#    ansible.install = false
#    ansible.playbook = "/vagrant/playbooks/ipa.yml"
#    ansible.compatibility_mode = "2.0"
#  end
 ipa.vm.provision :ansible_local do |ansible|
   ansible.playbook = "/vagrant/playbooks/master.yml"
   ansible.install = false
   ansible.compatibility_mode = "2.0"
   ansible.inventory_path = "/vagrant/inventory"
   ansible.config_file = "/vagrant/ansible.cfg"
   ansible.limit = "all"
  end
end
end



