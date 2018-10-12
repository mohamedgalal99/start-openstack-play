#!/bin/bash

MYSQL_ROOT_PW="R00t3r"

cat > create-heystonedb.sql << END
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY'Password1';
SHOW GRANTS FOR 'glance'@'%';
END

mysql -u root -p${MYSQL_ROOT_PW} < create-glance.sql
