#!/bin/bash

apt install -y glance python-glanceclient

cat > /etc/glance/glance-api.conf << END
[default]
notification_driver = noop
verbose = True

[database]
connection = mysql://keystone:Password1@controller/glance
backend = sqlalchemy

[glance_store]
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

[image_format]

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = Password1

[paste_deploy]
flavor = keystone
END

cat > /etc/glance/glance-registry.conf << END
[default]
notification_driver = noop
verbose = True

[database]
connection = mysql://keystone:Password1@controller/glance
backend = sqlalchemy

[glance_store]
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

[image_format]

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = Password1

[paste_deploy]
flavor = keystone
END

su -s /bin/sh -c "glance-manage db_sync" glance
service glance-registry restart
service glance-api restart

rm -rf /var/lib/glance/glance.sqlite
