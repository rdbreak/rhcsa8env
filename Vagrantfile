VAGRANT_DEFAULT_PROVIDER="virtualbox"
file_to_disk1 = './disk-0-1.vdi'
Vagrant.configure(2) do |config|
  # Use same SSH key for each machine
  config.ssh.insert_key = false
  config.vm.box_check_update = false

  # Repo Configuration
  config.vm.define "repo" do |repo|
    repo.vm.box = "rdbreak/rhel8repo"
    server1.vm.name = "server1"
  #  repo.vm.hostname = "repo.eight.example.com"
    repo.vm.network "private_network", ip: "192.168.55.149"
    repo.vm.provision "shell", :path => "files/setup.sh", reset: "true", run: "once"
  end

  # Server 1 Configuration
  config.vm.define "server1" do |server1|
    #  server1.vm.hostname = "server1.eight.example.com"
    server1.vm.name = "server1"
    server1.vm.box = "rdbreak/rhel8node"
    server1.vm.network "private_network", ip: "192.168.55.150"
    server1.vm.network "private_network", ip: "192.168.55.175"
    server1.vm.network "private_network", ip: "192.168.55.176"
    server1.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
    server1.vm.memory = "2048"
    server1.vm.provider "virtualbox" do |server1|
      server1.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata', '--portcount', 1]
      server1.customize ['createhd', '--filename', file_to_disk1, '--variant', 'Fixed', '--size', 10 * 1024]
      server1.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--type', 'hdd', '--medium', file_to_disk1]
      server1.customize ['modifyvm', '--memory', 2048]
      server1.customize ['modifyvm', '--nested-hw-virt', "on"]
      server1.customize ['modifyvm', '--audio', "null"]
    end
    server1.vm.provision "shell", reset: "true", run: "once" do |setup|
      setup.path    = "files/part_drive.sh"
      setup.inline  =  "echo Adding Brew Variables To Path'"
      setup.path    =  "files/setup.sh"
    end
    server1.vm.provision "shell", :path => "files/install_brew.sh", reset: "true", run: "once"
    server1.vm.provision "ansible_local" do |ansible|
      ansible.playbook           = "/vagrant/playbooks/main.yml"
      ansible.verbose            = true
      ansible.install            = true
      ansible.pip_install_cmd    = "python3 -m pip install"
      ansible.compatibility_mode = "2.0"
      ansible.inventory_path     = "/vagrant/inventory"
      ansible.config_file        = "/vagrant/ansible.cfg"
      ansible.limit              = "all"
      ansible.install_mode       = "pip"
    end
    server1.vm.provision "shell", reboot: "true", run: "once"
  end
end
