VAGRANTFILE_API_VERSION = "2"
VAGRANT_DISABLE_VBOXSYMLINKCREATE = "1"
file_to_disk1 = './disk-0-1.vdi'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Use same SSH key for each machine
config.ssh.insert_key = false
config.vm.box_check_update = false
config.vm.define "system" do |system|
  system.vm.box = "rdbreak/rhel8node"
#  system.vm.hostname = "system.eight.example.com"
  system.vm.network "private_network", ip: "192.168.55.151"
  system.vm.network "private_network", ip: "192.168.55.175"
  system.vm.network "private_network", ip: "192.168.55.176"
  system.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  system.vm.provider "virtualbox" do |system|
    system.memory = "1024"

    if not File.exist?(file_to_disk1)
      system.customize ['createhd', '--filename', file_to_disk1, '--variant', 'Fixed', '--size', 5 * 1024]
    end
    system.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata', '--portcount', 2]
    system.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk1]
  end
  
    system.vm.provision "shell", inline: <<-SHELL
    yes| sudo mkfs.ext4 /dev/sdb
    SHELL
  system.vm.provision :shell, :inline => "reboot", run: "always"
end
config.vm.define "repo" do |repo|
  repo.vm.box = "rdbreak/rhel8repo"
#  repo.vm.hostname = "repo.example.com"
  repo.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  repo.vm.provision :shell, :inline => "yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y; sudo yum install -y sshpass python3-pip python3-devel httpd sshpass vsftpd createrepo", run: "always"
  repo.vm.provision :shell, :inline => " python3 -m pip install -U pip ; python3 -m pip install pexpect; python3 -m pip install ansible", run: "always"
  repo.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  repo.vm.network "private_network", ip: "192.168.55.149"

  repo.vm.provider "virtualbox" do |repo|
    repo.memory = "1024"
  end
end
config.vm.define "ipa" do |ipa|
  ipa.vm.box = "rdbreak/rhel8node"
  ipa.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
#  ipa.vm.hostname = "ipa.eight.example.com"
  ipa.vm.network "private_network", ip: "192.168.55.150"
  ipa.vm.provider :virtualbox do |ipa|
    ipa.customize ['modifyvm', :id,'--memory', '2048']
    end
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



