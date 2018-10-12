#!/bin/bash

MYSQL_ROOT_PW="R00t3r"

cat > create-nova.sql << END
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY'Password1';
SHOW GRANTS FOR 'nova'@'%';
END

mysql -u root -p${MYSQL_ROOT_PW} < create-nova.sql
