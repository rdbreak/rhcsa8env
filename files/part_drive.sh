#!/bin/bash

echo ""
echo "Partitioning drive"
echo "----------------------------------------------------------------------"
echo ""
yes | mkfs.ext4 -L extradisk1 /dev/sdb
mkdir /extradisk1
echo \'LABEL=extradisk1 /extradisk1 ext4 defaults 0 0\' >>/etc/fstab
