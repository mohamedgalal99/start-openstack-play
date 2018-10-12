#!/bin/bash

MYSQL_ROOT_PW="R00t3r"

cat > create-heystonedb.sql << END
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY'Password1';
SHOW GRANTS FOR 'keystone'@'%';
END

mysql -u root -p${MYSQL_ROOT_PW} < create-keystone.sql
