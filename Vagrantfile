VAGRANTFILE_API_VERSION = "2"
VAGRANT_DISABLE_VBOXSYMLINKCREATE = "1"
file_to_disk1 = './disk-0-1.vdi'
file_to_disk2 = './disk-0-2.vdi'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Use same SSH key for each machine
config.ssh.insert_key = false
config.vm.box_check_update = false

# Repo Configuration
config.vm.define "repo" do |repo|
  repo.vm.box = "rdbreak/rhel8repo"
#  repo.vm.hostname = "repo.example.com"
  repo.vm.provision :shell, :inline => "sudo truncate -s0 /EMPTY; sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
  repo.vm.provision :shell, :inline => "yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y; sudo yum install -y sshpass python3-pip python3-devel httpd sshpass", run: "always"
  repo.vm.provision :shell, :inline => " python3 -m pip install -U pip ; python3 -m pip install pexpect", run: "always"
#   repo.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  repo.vm.network "private_network", ip: "192.168.55.149"
end

# Server 1 Configuration
config.vm.define "server1" do |server1|
  server1.vm.box = "rdbreak/rhel8node"
#  server1.vm.hostname = "server1.eight.example.com"
  server1.vm.network "private_network", ip: "192.168.55.150"
  server1.vm.network "private_network", ip: "192.168.55.175"
  server1.vm.network "private_network", ip: "192.168.55.176"
  server1.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  server1.vm.provider "virtualbox" do |server1|
    server1.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata', '--portcount', 2]

    unless File.exist?(file_to_disk1)
        server1.customize ['createhd', '--filename', file_to_disk1, '--variant', 'Fixed', '--size', 8 * 1024]
      end

      server1.memory = "2048"
      server1.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk1]
    end

    server1.vm.provision :shell, :inline => "sudo truncate -s0 /EMPTY; sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    server1.vm.provision :shell, :inline => "yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y; sudo yum install -y sshpass python3-pip python3-devel httpd", run: "always"
    server1.vm.provision :shell, :inline => "test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)", run: "always"
    server1.vm.provision :shell, :inline => "test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)", run: "always"
    server1.vm.provision :shell, :inline => "test -r ~/.bash_profile && echo \"eval \$($(brew --prefix)/bin/brew shellenv)\" >>~/.bash_profile", run: "always"
    server1.vm.provision :shell, :inline => "echo \"eval \$($(brew --prefix)/bin/brew shellenv)\" >>~/.profile", run: "always"
    server1.vm.provision :shell, :inline => "brew install podman", run: "always"
    server1.vm.provision "shell", inline: <<-SHELL
    yes|  mkfs.ext4 -L extradisk1 /dev/sdb
    SHELL
    server1.vm.provision "shell", inline: <<-SHELL
    mkdir /extradisk1 ; echo \'LABEL=extradisk1 /extradisk1 ext4 defaults 0 0\' >> /etc/fstab
    SHELL

      server1.vm.provision :ansible_local do |ansible|
     ansible.playbook = "/vagrant/playbooks/master.yml"
     ansible.install = false
     ansible.compatibility_mode = "2.0"
     ansible.inventory_path = "/vagrant/inventory"
     ansible.config_file = "/vagrant/ansible.cfg"
     ansible.limit = "all"
    end
    server1.vm.provision :shell, :inline => "reboot", run: "always"
end
end

