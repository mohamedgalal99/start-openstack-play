#!/bin/bash
# Run on compute nodes


cat > /etc/nova/nova.conf << END
[DEFAULT]
enabled_apis = osapi_compute,metadata
rpc_backend = rabbit
auth_strategy = keystone
my_ip = 192.168.103.253
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
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp
END

service nova-compute restart

rm -f /var/lib/nova/nova.sqlite