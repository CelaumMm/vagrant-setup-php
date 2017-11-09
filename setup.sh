#!/bin/bash

clear
echo "----------------------------------------------------------------"
echo "---- INICIANDO INSTALACAO DO AMBIENTE DE DESENVOLVIMENTO PHP ---"
echo "----------------------------------------------------------------"
echo ""

echo "------------------------------------"
echo "--- Atualizando lista de pacotes ---"
echo "------------------------------------"
sudo apt-get update
echo ""

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

echo "----------------------------------"
echo "--- Instalando pacotes basicos ---"
echo "----------------------------------"
sudo apt-get install vim curl python-software-properties git-core software-properties-common --assume-yes --force-yes
echo ""

echo "---------------------------------------------"
echo "--- Adicionando repositorio do pacote PHP ---"
echo "---------------------------------------------"
sudo add-apt-repository ppa:ondrej/php
echo ""

echo "------------------------------------"
echo "--- Atualizando lista de pacotes ---"
echo "------------------------------------"
sudo apt-get update
echo ""

echo "------------------------------------------------------------"
echo "--- Instalando MySQL, Phpmyadmin e alguns outros modulos ---"
echo "------------------------------------------------------------"
sudo apt-get install mysql-server-5.5 mysql-client phpmyadmin --assume-yes --force-yes
echo ""

echo "-----------------------------------------------"
echo "--- Instalando PHP, Apache e alguns modulos ---"
echo "-----------------------------------------------"
sudo apt-get install php7.1 php7.1-common --assume-yes --force-yes
sudo apt-get install php7.1-cli libapache2-mod-php7.1 php7.1-mysql php7.1-curl php-memcached php7.1-dev php7.1-mcrypt php7.1-sqlite3 php7.1-mbstring zip unzip --assume-yes --force-yes
echo ""


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