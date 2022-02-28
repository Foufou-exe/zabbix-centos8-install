#!/bin/bash
#UTF-8 encoded

#<---------- Declaration of Functions ---------->

function install-packages-zabbix() { #  install packages zabbix function: It aims to gather all packages and install them for zabbix
    dnf install -y build-essential libmariadb-dev sudo libxml2-dev snmp libsnmp-dev libcurl4-openssl-dev php-gd php-xml php-bcmath php-mbstring vim libevent-dev libpcre3-dev libxml2-dev libmariadb-dev libapache2-mod-php libopenipmi-dev pkg-config php-ldap php-mysql apache2 php mariadb-server snmp curl git python3 python3-pip
    rpm -Uvh https://repo.zabbix.com/zabbix/5.4/rhel/8/x86_64/zabbix-release-5.4-1.el8.noarch.rpm
    dnf clean all
    dnf install mariadb-server php zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-agent
}
function zabbix-server() {  #  zabbix-server function: The goal is to create a sql file to group the commands and then ask the user to put a password and then put everything into operation
    read -p "Provide a password for the Zabbix Server user :" password
    touch zabbix-sql-server.sql
    echo "create database zabbix character set utf8 collate utf8_bin;">zabbix-sql-server.sql
    echo "create user zabbix@localhost identified by '$password';">>zabbix-sql-server.sql
    echo "grant all privileges on zabbix.* to zabbix@localhost;">>zabbix-sql-server.sql
    mysql -u root <zabbix-sql-server.sql
    zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -u zabbix -p $password
    sed -i "s/DBPassword=/DBPassword=$password/">/etc/zabbix/zabbix_server.conf
    systemctl restart zabbix-server zabbix-agent httpd php-fpm
    systemctl enable zabbix-server zabbix-agent httpd php-fpm
}

function Description-Zabbix() { # Description-Zabbix function: The goal is to inform the user that he has finished the installation and give him the url of the site and the login
    IP=$(hostname -I)
    echo -e "Here it is all set up /nYou can finally access your site : https://$IP/zabbix/ /n Username : admin /n Password : zabbix"
}

function main() {   #   main function : The goal is to gather all the functions to make the script work
    install-packages-zabbix
    zabbix-server
    Description-Zabbix
    echo "By Foufou-exe | https://github.com/Foufou-exe | GNU GPL v3 /nThanks to you ❤️ "
}

#<------- Using the Functions ---------->

main
