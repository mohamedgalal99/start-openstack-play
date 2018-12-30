#!/bin/bash
# openstack Ice House Release on ubuntu 14.04.5

hostname="controller-01"

apt install software-properties-common chrony vim -y
apt-add-repository cloud-archive:liberty
apt update

hostnamectl set-hostname ${hostname}
[[ -d "/etc/ssh" ]] && rm -rf /etc/ssh/ssh_host* || { echo "[-] /etc/ssh not found"; exit 1; }
dpkg-reconfigure openssh-server
ssh-keygen

apt install chrony
echo "[+] NTP source we use:"
chronyc sources 

apt install python-openstackclient -y
echo "[+] Openstack version is: $(openstack --version)"

echo -e "[+] Nova version:\n $(dpkg -l | grep python-nova)"
echo -e "[+] Glance version:\n $(dpkg -l | grep python-glance)"
echo -e "[+] Neutron version:\n $(dpkg -l | grep python-neut)"


echo "[...] Start installing mysql"
apt install mysql-server python-mysqldb -y
[[ -d "/etc/mysql" ]] || { echo "[-] Can't find dir /etc/mysql"; exit 2 }
cat > /etc/mysql/config.d/openstack.cnf << END
[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8‘
character-set-server = utf8
END

service mysql restart
# systemctl restart mysql


echo "[...] Start install rabbitmq"
apt install rabbitmq-server -y
echo "[...] Add openstack user"
rabbitmqctl add_user openstack P@ssw0rd
echo "[...] Configure openstack user permissions"
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# rabbitmqctl list_users
# rabbitmqctl list_user_permistions openstack
