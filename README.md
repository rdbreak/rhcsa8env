# RHCSA 8 Study/Test Environment powered by Ansible and Vagrant. 

## Required software before setting up:
- Ansible - (`yum install ansible` or `brew install ansible`)
- Python - (`yum install python`or `brew install python`)
- [Vagrant](https://www.vagrantup.com/downloads.html) - (`brew cask install vagrant`)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (`brew cask install VirtualBox`)

### Install at once with the command below:
(`brew install ansible ; brew install python ; brew cask install vagrant ; brew cask install VirtualBox`)

If you're using a Mac, Gatekeeper will block virtualbox from installing. All you have to do is go to System Preferences and click Allow under the General tab and rerun installation.

## Set Up Instructions
1. Create a seperate `~/bin` directory and `cd` to it. 
2. Clone the environment repo to it with `git clone https://github.com/rdbreak/rhcsa8env.git`
3. Change to the `rhcsa8env` directory that is now in your `~/bin` directory.
3. Run `vagrant up --provider virtualbox` to deploy the environment _(You must be in the directory you cloned the repo to in order to run vagrant commands.)_

*Also, don't be spooked by any red font during the setup process. It won't have an affect on your exam environment.* 

_NOTE - You can use the VirtualBox console to interact with the VMs or through a terminal. If you need to reset the root password, you would need to use the console though._

The first time you run the vagrant up command, it will download the OS images for later use. In other words, it will take longest the first time around but will be faster when it is deployed again. You can run `vagrant destroy -f` to destroy your environment at anytime. **This will erase everything**. This environment is meant to be reuseable, If you run the `vagrant up --provider virtualbox` command after destroying the environment, the OS image will already be downloaded and environment will deploy faster. Deployment should take around 10 minutes depending on your computer. You shouldn't need to access the IPA server during your exam. Everything should be provided that you would normally need during an actual exam. Hope this helps in your studies!

### This environment includes two systems:
- system.eight.example.com

### Network Details:
###### system
192.168.55.151

### Accessing the systems
Remember to add the IP addresses to your local host file if you want to connect to the guest systems with the hostname.
Username - vagrant
Password - vagrant
- For root - use `sudo` or `sudo su`

## Help
If you're having problems with the environment, please submit an issue by going to the `ISSUES` tab at the top. If you have more questions, looking for practice exams to use against this environment, or just looking for a fantastic Red Hat community to join, please navigate to #practiceexam in the [Red Hat Certs Slack Workspace](https://join.slack.com/t/redhat-certs/shared_invite/enQtNjAxNDc3MzYyMTAxLWZlM2ZhMGRlNGI2YjQyMzQ4NWEyNDIyYTJiNzcxM2E1ZDVkZmQ4MzU2MTc0ZDRlNzg2MTU5NWIwZjFjZDdjMGE).
