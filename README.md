# RHCSA 8 Study/Test Environment powered by Ansible and Vagrant. 

## Install the following software before setting up:
###### macOS
_Gatekeeper will block virtualbox from installing. All you have to do is go to Security & Privacy of System Preferences and click Allow under the General tab and rerun installation._
- [Latest Version of Vagrant](https://www.vagrantup.com/downloads.html) - (`brew cask install vagrant`)
    - Vagrant Plugin - `vagrant plugin install vagrant-guest_ansible`
- [Latest Version of Virtualbox](https://www.virtualbox.org/wiki/Downloads) (`brew cask install VirtualBox`)
- Virtual Box Extension Pack (`brew cask install virtualbox-extension-pack`)
###### Install at once with the command below (Mac only): 
`brew install ansible ; brew install python ; brew cask install vagrant ; brew cask install VirtualBox ; brew cask install virtualbox-extension-pack`

###### CentOS/RHEL
- [Latest Version of Virtualbox and Virtual Box Extension Pack](https://www.virtualbox.org/wiki/Downloads) 
- [Latest Version of Vagrant](https://www.vagrantup.com/downloads.html) - `wget https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_i686.rpm ; yum –y localinstall vagrant_2.2.5_x86_64.rpm` 
- Ansible Guest Vagrant Plugin `vagrant plugin install vagrant-guest_ansible`

###### Debian
- Vagrant - `sudo apt install vagrant`
- Vagrant Plugin - `vagrant plugin install vagrant-guest_ansible`
- [Latest Version of Virtualbox and Virtual Box Extension Pack](https://www.virtualbox.org/wiki/Downloads)

_Now you should be ready to follow the next steps and get the deployment up and running!_

## Once the above software is installed. Do the following if you're running the environment on Mac/Linux:
1. Create a separate `~/bin` directory and `cd` to it.  (The directory doesn't have to be ~/bin, it can be anything you want.)
2. Clone the environment repo to it with `git clone https://github.com/rdbreak/rhcsa8env.git`
3. Change to the `rhcsa8env` directory that is now in your `~/bin` directory.
3. Run `vagrant up --provider virtualbox` to deploy the environment 

## Once the above software is installed. Do the following if you're running the environment on Windows:
1. Create a separate `~/bin` directory and `cd` to it.  (The directory doesn't have to be ~/bin, it can be anything you want.)
2. Use your browser of choice and navigate to https://github.com/rdbreak/rhcsa8env, press the green “Clone or download” button then the “Download ZIP” button.
3. Once downloaded, unzip the file and move it to the directory you created earlier.
3. Open CMD prompt and cd to the repo directory then run `vagrant up --provider virtualbox` to deploy the environment

*Also, don't be spooked by any scary red font during the setup process. There are known issues that won't have a negative affect on the environment.* 

_NOTE - You can also use the VirtualBox console to interact with the VMs or through a terminal. If you need to reset the root password, you would need to use the console._

## (Optional) Install Github Desktop to make pulling down changes easier
_NOTE this requires a free Github account_
1. Navigate to https://desktop.github.com/ and download Github Desktop.
2. Create or sign in to your account.
3. Clone or pull changes to respctive repo

## Other Useful Information:
I'm constantly making upgrades to the environments, so every once and awhile run `git pull` in the repo directory to pull down changes. The first time you run the vagrant up command, it will download the OS images for later use. In other words, it will take longest the first time around but will be faster when it is deployed again. You can run `vagrant destroy -f` to destroy your environment at anytime. **This will erase everything**. This environment is meant to be reuseable, If you run the `vagrant up --provider virtualbox` command after destroying the environment, the OS image will already be downloaded and environment will deploy faster. Deployment should take around 7 minutes depending on your computer. Everything should be provided that you would normally need during an actual exam. Hope this helps  in your studies!

### This environment includes two systems:
- ipa.eight.example.com
- system.eight.example.com

### Network Details:
###### ipa
192.168.55.150
###### system
192.168.55.151

### Accessing the systems
Remember to add the IP addresses to your local host file if you want to connect to the guest systems with the hostname.
Username - vagrant
Password - vagrant
- For root - use `sudo` or `sudo su`
Access example - `ssh vagrant@192.168.55.151` or `vagrant ssh system`

##Known Issues
Currently there is an issue with the named services during the IPA server setup. This doesn't seem to impact the environment at the moment. Please reach out if it does.

## Help
If you're having problems with the environment, please submit an issue by going to the `ISSUES` tab at the top. If you have more questions, looking for practice exams to use against this environment, or just looking for a fantastic Red Hat community to join, please navigate to #practiceexam in the [Red Hat Certs Slack Workspace](https://join.slack.com/t/redhat-certs/shared_invite/enQtNjI4Mjk1OTA4NDk4LTBiMWQ1OGM5MmJhZjhlNGZiNjMxYmViMGI2OTdjMDY4NjZkYTliYTE4M2IwYzFkYTJlMThjNmFlNDZmOTIyZTQ).
