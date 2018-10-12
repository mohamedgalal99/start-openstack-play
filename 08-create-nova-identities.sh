#!/bin/bash

source /root/adminrc.sh

openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" nova

openstack endpoint create --region RegionOne nova public http://controller:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne nova internal http://controller:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne nova admin http://controller:8774/v2/%\(tenant_id\)s 



apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient
