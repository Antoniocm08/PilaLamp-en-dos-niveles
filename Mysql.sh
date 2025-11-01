#!/bin/bash

# Actualiza repositorios e instalar MariaDB
sudo apt update
sudo apt install -y mariadb-server

# Habilitar y arrancar el servicio 
sudo systemctl enable mariadb || systemctl enable mysql
sudo systemctl start mariadb || systemctl start mysql

# Crear la base de datos y el usuario
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'Antonio'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'Antonio'@'%';
FLUSH PRIVILEGES;
EOF
echo "✅ Servidor MySQL configurado y base de datos creada correctamente."

echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# Instalar phpMyAdmin 
sudo apt install -y phpmyadmin

# Habilitar extensiones del php
sudo phpenmod mbstring
sudo systemctl restart apache2

# Configurar el  acceso remoto 
sudo sed -i 's/Require local/Require all granted/' /etc/apache2/conf-available/phpmyadmin.conf
sudo systemctl restart apache2

echo " Instalacion completada. Accede a phpMyAdmin en http://localhost/phpmyadmin "
#Desactiva el internet
sudo ip route del default
