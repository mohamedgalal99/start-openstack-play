#!/bin/bash

cat > /etc/nova/nova.conf << END
[DEFAULT]
enabled_apis = osapi_compute,metadata
rpc_backend = rabbit
auth_strategy = keystone
my_ip = 192.168.103.254
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
dhcpbridge_flagfile=/etc/nova/nova.conf 
dhcpbridge=/usr/bin/nova-dhcpbridge 
logdir=/var/log/nova 
state_path=/var/lib/nova 
lock_path=/var/lock/nova 
force_dhcp_release=True 
libvirt_use_virtio_for_bridges=True 
verbose=True 
ec2_private_dns_show_ip=True 
api_paste_config=/etc/nova/api-paste.ini 


[api_database]
connection = mysql+pymysql://nova:Password1@controller/nova

[database]
connection = mysql+pymysql://nova:Password1@controller/nova

[oslo_messaging_rabbit]
rabbit_host = controller
rabbit_userid = openstack
rabbit_password = Password1


[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = Password1

[vnc]
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip

[glance]
#api_servers = http://controller:9292
host = controller

[oslo_concurrency]
lock_path = /var/lib/nova/tmp
END

su -s /bin/sh -c "nova-manage db sync" nova
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
