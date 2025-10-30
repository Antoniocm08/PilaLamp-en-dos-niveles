#!/bin/bash

# Actualiza repositorios e instalar MariaDB
sudo apt update
sudo apt install -y mariadb-server

#Desactiva el internet 
sudo ip route del default

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

