#!/bin/bash

# Install and configure keystone on controller

mysql_passwd="rooter"

echo "[...] Create keystone database"
cat > /tmp/create-heystonedb.sql << END
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'P@ssw0rd';
SHOW GRANTS FOR 'keystone'@'%';
END

[[ -f "/tmp/create-heystonedb.sql" ]] || { echo "[-] Can't find sql file /tmp/create-heystonedb.sql to create keystone db"; exit 1; }

mysql -u root -p${mysql_passwd} < /tmp/create-heystonedb.sql



## Running on controller
# don't need it to start as we using apache
echo "manual" > /etc/init/keystone.override

apt-get install keystone apache2 libapache2-mod-wsgi memcached python-memcache -y



# Configure keystone
cat > /etc/keystone/keystone.conf << END
[DEFAULT]
verbose = True
admin_token = P@ssw0rd     # make var in start of script
log_dir = /var/log/keystone

[database]
connection = mysql://root:rooter@$(hostname)/keystone    # configure db connection, should be changed and make var in begin of script

[memcache]
servers = localhost:11211

[revoke]
driver = sql

[token]
provider = uuid
driver = memcache

[extra_headers]
Distribution = Ubuntu
END



# populate ks db
su -s /bin/sh -c "keystone-manage db_sync" keystone

# Create VHOST
cat > /etc/apache2/sites-available/wsgi-keystone.conf << END
Listen 5000
Listen 35357

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /usr/bin/keystone-wsgi-public
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/apache2/keystone.log
    CustomLog /var/log/apache2/keystone_access.log combined

    <Directory /usr/bin>
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/apache2/keystone.log
    CustomLog /var/log/apache2/keystone_access.log combined

    <Directory /usr/bin>
        Require all granted
    </Directory>
</VirtualHost>
END


# Enable VHost
a2ensite wsgi-keystone.conf

#Set host name globaly
## echo "ServerName contoller" >> /etc/apachec2/apache2.conf



service apache2 restart

# Remove SQL lite db
[[ -f "/var/lib/keystone/keystone.db" ]] && rm -f /var/lib/keystone/keystone.db
