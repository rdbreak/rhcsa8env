VAGRANTFILE_API_VERSION = "2"
VAGRANT_DISABLE_VBOXSYMLINKCREATE = "1"
file_to_disk1 = './disk-0-1.vdi'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
## Use same SSH key for each machine
#config.ssh.insert_key = false
#config.vm.box_check_update = false
#config.vm.define "ipa" do |ipa|
#  ipa.vm.box = "generic/oracle8"
#  ipa.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
#  ipa.vm.provision :shell, :inline => "ln -s /usr/bin/python3.6 /usr/bin/python", run: "always"
##  ipa.vm.provision :shell, :inline => "sudo yum install -y epel-release; sudo yum -y install python36; sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py ; python get-pip.py ; sudo pip3 install -U pip ; sudo pip3 install pexpect;", run: "always"
#  ipa.vm.provision :shell, :inline => "sudo mkdir -p /var/www/html/rpms;", run: "always"
#  ipa.vm.provision :shell, :inline => "for i in \"Development Tools\" \"Container Management\" \"Workstation\" \"Graphical Administration Tools\" ; do yum group install \"$i\" -y --downloadonly --downloaddir=/var/www/html/rpms;done;", run: "always"
#  ipa.vm.provision :shell, :inline => "yum install -y httpd-manual selinux\* sssd\* --downloadonly --downloaddir=/var/www/html/rpms;", run: "always"
#  ipa.vm.hostname = "ipa.eight.example.com"
#  ipa.vm.network "private_network", ip: "192.168.55.150"
#  ipa.vm.provider :virtualbox do |ipa|
#    ipa.customize ['modifyvm', :id,'--memory', '2048']
#    end
#end
  
config.vm.define "system" do |system|
  system.vm.box = "generic/oracle8"
  system.vm.hostname = "system.eight.example.com"
  system.vm.network "private_network", ip: "192.168.55.151"
  system.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  system.vm.provision :shell, :inline => "sudo yum install -y python2 python36 libselinux-devel", run: "always"
  system.vm.provision :shell, :inline => "ln -s /usr/bin/python3.6 /usr/bin/python", run: "always"
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
  system.vm.provision "ansible" do |ansible|
    ansible.version = "latest"
    ansible.limit = "all"
    ansible.playbook = 'playbooks/system.yml'
  end
end
end



