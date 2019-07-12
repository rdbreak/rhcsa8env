# Vagrant/Ansible for RHCSA Study/Test Environment.

## Required software before setting up:
- Ansible - (`yum install ansible` or `brew install ansible`)
- Python - (`yum install python`or `brew install python`)
- [Vagrant](https://www.vagrantup.com/downloads.html) - (`brew cask install vagrant`)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (`brew cask install VirtualBox`)

This environment is meant to be reproducable. Meaning the first time `vagrant up --provider virtualbox` is run, it will take the longest. You can run `vagrant destroy -f` to erase your environment. When you run the vagrant up command above once more, the OS image will already be downloaded and environment will build faster everytime after that. 

The machines will take about 10 minutes to fully set up and then they will reboot at the end.

### It includes two systems:
- ipa.example.com
- system1.example.com

### Network Details:
###### ipa
192.168.55.5
###### system1
192.168.55.6


# ipasetup
# ipasetup
# ipasetup
