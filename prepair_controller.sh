#!/bin/bash

apt update && apt upgrade -y
apt install -y software-properties-common chrony vim
apt-add-repository cloud-archive:liberty
apt update

# set static network config
# In vim :set ai   => to make algin lines

hostnamectl set-hostname cintroller
rm rf /etc/ssh/ssh_host*
dpkg-reconfigure openssh-server
ssk-keygen

apt install chrony
chronyc source     # get from where we read NTP spurce
vim /etc/chrony/chrony.conf #on other nodes, not controller
   # server controller iburst
systemctl restart chrony 
