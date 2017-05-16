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

# Update packages and Upgrade system
echo -e "$Cyan \n Updating System.. $Color_Off"
sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install git vim

## Install LAMP
echo -e "$Cyan \n Installing Apache2 and PHP $Color_Off"

sudo apt-get install software-properties-common

sudo apt-add-repository -y ppa:ondrej/php 
sudo apt-add-repository -y ppa:ondrej/mysql-5.5
sudo apt-get -y update

sudo apt-get -y install php5.6-mysql php5.6-cli php5.6-curl php5.6-json php5.6-sqlite3 php5.6-mcrypt php5.6-curl 
php-xdebug php5.6-mbstring libapache2-mod-php5.6 mysql-server php5-mysql

sudo apt-get install apache2 libapache2-mod-php5

sudo a2enmod php5.6 

echo 2 | sudo update-alternatives --config php

sudo apt-get update

sudo add-apt-repository ppa:nijel/phpmyadmin;

sudo apt-get update

sudo apt-get install phpmyadmin


echo -e "$Cyan \n NodeJS and npm install $Color_Off"
sudo apt-get install nodejs npm -y
sudo ln -s /usr/bin/nodejs /usr/bin/node

#Install composer 
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

echo -e "$Cyan \n Removing apache files $Color_Off"
sudo rm /etc/php/5.6/apache2/php.ini /etc/php/5.6/cli/php.ini /etc/hosts

echo -e "$Cyan \n Adding apache sites configuration $Color_Off"
sudo cp /var/www/vagrant-stuffs/apache-conf/transmeo.conf /etc/apache2/sites-available/

echo -e "$Cyan \n Adding apache config files php.ini and hosts $Color_Off"
sudo cp /var/www/vagrant-stuffs/apache-conf/cli-php.ini /etc/php/5.6/cli/php.ini
sudo cp /var/www/vagrant-stuffs/apache-conf/apache-php.ini /etc/php/5.6/apache2/php.ini
sudo cp /var/www/vagrant-stuffs/apache-conf/hosts /etc/hosts

echo -e "$Cyan \n Enabling apache sites $Color_Off"
sudo a2ensite transmeo.conf
sudo a2enmod rewrite
sudo service apache2 restart

echo -e "$Cyan \n Adding rsa key to ssh agent $Color_Off"
eval "$(ssh-agent -s)"
mkdir -p ~/.ssh
echo -e "$Cyan \n Copy rsa key to ssh folder $Color_Off"
cp /var/www/vagrant-stuffs/id_rsa ~/.ssh
echo -e "$Cyan \n Change rsa key mode to 400 $Color_Off"
chmod 400 ~/.ssh/id_rsa
echo -e "$Cyan \n Add rsa key to ssh agent $Color_Off"
ssh-add ~/.ssh/id_rsa

ssh-keyscan -H github.com >> ~/.ssh/known_hosts && chmod 600 ~/.ssh/known_hosts


sudo service apache2 restart

cd /var/www/transmeo
composer update

npm install 

exit
