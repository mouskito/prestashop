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

echo -e "$Cyan \n Add php apt repository $Color_Off"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get install python-software-properties

# Update packages and Upgrade system
echo -e "$Cyan \n Updating System.. $Color_Off"
sudo apt-get update -y && sudo apt-get upgrade -y

echo -e "$Cyan \n MySQL Config $Color_Off"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password paris'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password paris'
sudo apt-get install -y mysql-server
sudo mysqld --initialize

## Install LAMP
echo -e "$Cyan \n Installing Apache2 $Color_Off"
sudo apt-get install apache2 -y
sudo service apache2 restart

echo -e "$Cyan \n Installing PHP extensions $Color_Off"
sudo apt install --no-install-recommends php7.1 libapache2-mod-php7.1 php7.1-mysql php7.1-curl php7.1-json php7.1-gd php7.1-mcrypt php7.1-msgpack php7.1-memcached php7.1-intl php7.1-sqlite3 php7.1-gmp php7.1-geoip php7.1-mbstring php7.1-redis php7.1-xml php7.1-zip
sudo apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev libsslcommon2-dev curl libcurl4-doc libcurl3-dbg libidn11-dev libkrb5-dev libldap2-dev librtmp-dev php-cli php-dev php-common php-cgi

#Install composer 
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

echo -e "$Cyan \n Removing apache files $Color_Off"
# sudo rm /etc/php/apache2/php.ini /etc/php/cli/php.ini /etc/hosts
sudo rm /etc/hosts

echo -e "$Cyan \n Adding apache sites configuration $Color_Off"
sudo cp /var/www/vagrant-stuffs/apache-conf/cardif.conf /etc/apache2/sites-available/

echo -e "$Cyan \n Adding apache config files php.ini and hosts $Color_Off"
# sudo cp /var/www/vagrant-stuffs/apache-conf/cli-php.ini /etc/php/7.1/cli/php.ini
# sudo cp /var/www/vagrant-stuffs/apache-conf/apache-php.ini /etc/php/7.1/apache2/php.ini
sudo cp /var/www/vagrant-stuffs/apache-conf/hosts /etc/hosts

echo -e "$Cyan \n Enabling apache sites $Color_Off"
sudo a2ensite cardif.conf
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

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

sudo apt-get install git -y

## Installing ruby for SASS and Compass support
echo -e "$Cyan \n Installing ruby for SASS and Compass support $Color_Off"
sudo apt-get install ruby-full build-essential libssl-dev -y

sudo gem update -f
sudo gem install compass

echo -e "$Cyan \n Installing Nodejs npm with nvm $Color_Off"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh -o install_nvm.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.profile
nvm install 6.10

echo -e "$Cyan \n NodeJS and npm install $Color_Off"
sudo ln -s /usr/bin/nodejs /usr/bin/node

sudo npm install -g typescript gulp-cli concurrently typings grunt-cli bower cordova ionic pm2 forever express-generator nodemon@1.10.1 strongloop

ssh-keyscan -H github.com >> ~/.ssh/known_hosts && chmod 600 ~/.ssh/known_hosts

sudo service apache2 restart

exit;
