#!/bin/bash
# Run on compute node

apt install -y python-openstackclient
apt install -y nova-compute sysfsutils
openstack --version
