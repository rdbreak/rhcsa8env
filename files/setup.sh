#!/bin/bash

echo ""
echo "Installing EPEL8"
echo "----------------------------------------------------------------------"
echo ""
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
echo "Done!"
echo ""
echo "Installing Necessary Packages"
echo "----------------------------------------------------------------------"
echo
sudo yum install -y sshpass python3-pip python3-devel httpd
echo "Done!"

echo "Installing Pip and Packages"
echo "----------------------------------------------------------------------"
echo ""
python3 -m pip install -U pip
python3 -m pip install pexpect
echo "Done!"

echo "Freeing Up Disk Space"
echo "----------------------------------------------------------------------"
echo ""
sudo truncate -s0 /EMPTY
echo "Done!"

echo "Setting Auth Method"
echo "----------------------------------------------------------------------"
echo ""
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo "Done!"

echo "Restarting sshd Service"
echo "----------------------------------------------------------------------"
echo ""
sudo systemctl restart sshd
echo "Done!"
echo ""
