#!/bin/bash

clear

echo "----------------------------------------------------------------"
echo "---- INICIANDO INSTALACAO DO AMBIENTE DE DESENVOLVIMENTO PHP ---"
echo "----------------------------------------------------------------"
echo ""

echo "------------------------------------------------------------------"
echo "--- Adicionando repositorio atual do pacote PHP, APACHE, MYSQL ---"
echo "------------------------------------------------------------------"
sudo apt-get install python-software-properties -y

sudo add-apt-repository ppa:ondrej/php
#sudo add-apt-repository ppa:ondrej/apache2
sudo add-apt-repository ppa:ondrej/mysql-5.7
sudo add-apt-repository ppa:nijel/phpmyadmin
echo ""

echo "------------------------------------"
echo "--- Atualizando lista de pacotes ---"
echo "------------------------------------"
sudo apt-get update && sudo apt-get -y upgrade
echo ""

clear

echo "--------------------------------------------------------------"
echo "--- Definindo Senha padrao para o MySQL e suas ferramentas ---"
echo "--------------------------------------------------------------"
DEFAULTPASS="vagrant"
sudo debconf-set-selections <<EOF
mysql-server	mysql-server/root_password password $DEFAULTPASS
mysql-server	mysql-server/root_password_again password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/app-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/mysql/admin-pass password $DEFAULTPASS
dbconfig-common	dbconfig-common/password-confirm password $DEFAULTPASS
dbconfig-common	dbconfig-common/app-password-confirm password $DEFAULTPASS
phpmyadmin		phpmyadmin/reconfigure-webserver multiselect apache2
phpmyadmin		phpmyadmin/dbconfig-install boolean true
phpmyadmin      phpmyadmin/app-password-confirm password $DEFAULTPASS 
phpmyadmin      phpmyadmin/mysql/admin-pass     password $DEFAULTPASS
phpmyadmin      phpmyadmin/password-confirm     password $DEFAULTPASS
phpmyadmin      phpmyadmin/setup-password       password $DEFAULTPASS
phpmyadmin      phpmyadmin/mysql/app-pass       password $DEFAULTPASS
EOF
echo ""

clear

echo "----------------------------------"
echo "--- Instalando pacotes basicos ---"
echo "----------------------------------"
sudo apt-get install vim curl git-core software-properties-common --assume-yes --force-yes
echo ""

clear

echo "------------------------------------------------------------"
echo "--- Instalando MySQL, Phpmyadmin e alguns outros modulos ---"
echo "------------------------------------------------------------"
sudo apt-get install mysql-server-5.5 mysql-client phpmyadmin --assume-yes --force-yes
echo ""
echo "Copiando as configurações do phpmyadmin"
echo "---------------------------------------"
sudo cp -r -f /vagrant/config/etc/phpmyadmin/. /etc/phpmyadmin/.
echo ""

clear

echo "----------------------"
echo "--- Instalando PHP ---"
echo "----------------------"
sudo apt-get install php7.1 php7.1-common --assume-yes --force-yes

echo "--------------------------"
echo "--- Instalando modulos ---"
echo "--------------------------"
sudo apt-get install php7.1-cli --assume-yes --force-yes
sudo apt-get install libapache2-mod-php7.1 --assume-yes --force-yes
sudo apt-get install php7.1-mysql --assume-yes --force-yes
sudo apt-get install php7.1-curl --assume-yes --force-yes
sudo apt-get install php-memcached --assume-yes --force-yes
sudo apt-get install php7.1-dev --assume-yes --force-yes
sudo apt-get install php7.1-mcrypt --assume-yes --force-yes
sudo apt-get install php7.1-sqlite3 --assume-yes --force-yes
sudo apt-get install php7.1-mbstring --assume-yes --force-yes
sudo apt-get install zip --assume-yes --force-yes
sudo apt-get install unzip --assume-yes --force-yes
echo ""

clear

echo "-----------------------------"
echo "--- Habilitando o PHP 7.1 ---"
echo "-----------------------------"
sudo a2dismod php5
sudo a2enmod php7.1
echo ""

echo "-----------------------------------------"
echo "--- Habilitando mod-rewrite do Apache ---"
echo "-----------------------------------------"
sudo a2enmod rewrite
echo ""

echo "--------------------------------------------"
echo "--- Copiando as configuracoes do Apache  ---"
sudo cp -f /vagrant/config/etc/apache2/sites-available/* /etc/apache2/sites-available/
echo ""

echo "--------------------------"
echo "--- Reiniciando Apache ---"
echo "--------------------------"
sudo service apache2 restart
echo ""

echo "--------------------------------------"
echo "--- Baixando e Instalando Composer ---"
echo "--------------------------------------"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
echo ""

echo "------------------------------------------"
echo "--- Instalando Banco NoSQL -> Redis <- ---"
echo "------------------------------------------"
sudo apt-get install redis-server --assume-yes
sudo apt-get install php7.1-redis --assume-yes
echo ""

echo "---------------------------------------------------"
echo "--- Copiando as configuracoes do arquivo hosts  ---"
echo "---------------------------------------------------"
sudo cp -f /vagrant/config/etc/hosts /etc/hosts
echo ""

echo "--------------------------------------------------"
echo "[OK] --- AMBIENTE DE DESENVOLVIMENTO CONCLUIDO ---"
echo "--------------------------------------------------"