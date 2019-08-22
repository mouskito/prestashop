#!/usr/bin/env bash

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

#** Fix locale Mac Lion notice
#********************************************************************
sudo locale-gen
sudo apt-get install vim

sudo apt-get update && sudo apt-get upgrade

sudo apt-get install apache2 -y

echo -e "$Cyan \n MySQL Config $Color_Off"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password paris'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password paris'
sudo apt-get install -y mysql-server
sudo mysqld --initialize
# Create new MySQL user to access database
mysql -uroot -pparis -e "CREATE DATABASE IF NOT EXISTS prestashop";
mysql -uroot -pparis -e "CREATE USER 'iknsa'@'localhost' IDENTIFIED BY 'paris'";
mysql -uroot -pparis -e "CREATE USER 'iknsa'@'%' IDENTIFIED BY 'paris'";
mysql -uroot -pparis -e "GRANT ALL PRIVILEGES ON * . * TO 'iknsa'@'localhost'";
mysql -uroot -pparis -e "GRANT ALL PRIVILEGES ON *. * TO 'iknsa'@'%'";
mysql -uroot -pparis -e "FLUSH PRIVILEGES";

## Install LAMP
echo -e "$Cyan \n Installing Apache2 $Color_Off"
sudo apt-get install apache2 -y
sudo service apache2 restart

echo -e "$Cyan \n Installing PHP extensions $Color_Off"
sudo apt install -y --no-install-recommends php libapache2-mod-php php-mysql php-curl php-json php-gd php-mcrypt php-msgpack php-memcached php-intl php-sqlite3 php-gmp php-geoip php-mbstring php-redis php-xml php-zip
#sudo apt install -y --no-install-recommends php5.6 libapache2-mod-php5.6 php5.6-mysql php5.6-curl php5.6-json php5.6-gd php5.6-mcrypt php5.6-msgpack php5.6-memcached php5.6-intl php5.6-sqlite3 php5.6-gmp php5.6-geoip php5.6-mbstring php5.6-redis php5.6-xml php5.6-zip
sudo apt install -y libcurl4-openssl-dev pkg-config libssl-dev libsslcommon2-dev curl libcurl4-doc libcurl3-dbg libidn11-dev libkrb5-dev libldap2-dev librtmp-dev php-cli php-dev php-common php-cgi

echo -e "$Cyan \n Removing apache files $Color_Off"
# sudo rm /etc/php/apache2/php.ini /etc/php/cli/php.ini /etc/hosts
sudo rm /etc/hosts

echo -e "$Cyan \n Adding apache sites configuration $Color_Off"
sudo cp /var/www/vagrant-stuffs/apache-conf/iknsa.conf /etc/apache2/sites-available/

echo -e "$Cyan \n Adding apache config files php.ini and hosts $Color_Off"
sudo cp /var/www/vagrant-stuffs/apache-conf/cli-php.ini /etc/php/7.3/cli/php.ini
sudo cp /var/www/vagrant-stuffs/apache-conf/apache-php.ini /etc/php/7.3/apache2/php.ini
sudo cp /var/www/vagrant-stuffs/apache-conf/hosts /etc/hosts

#
cd /home/ubuntu

# Install PrestaShop
echo "Instalando PrestaShop"
echo "---------------------"
mkdir /var/www/projects/prestashop
cd /var/www/projects/prestashop
sudo curl -O https://download.prestashop.com/download/releases/prestashop_1.7.2.1.zip
sudo apt-get install unzip
sudo unzip prestashop_1.7.2.1.zip
sudo apt-get install php7.0-curl php7.0-gd php7.0-mysql php7.0-zip php7.0-xml php7.0-intl

#mv prestashop/* .
#rm Install_PrestaShop.html

echo -e "$Cyan \n Enabling apache sites $Color_Off"
sudo a2ensite iknsa.conf
sudo a2enmod rewrite
sudo service apache2 restart

