## 🧱 **Pila LAMP en Dos Niveles**
### 🚀 Práctica: Despliegue de Aplicación en Infraestructura de Dos Niveles con Vagrant

----

## 📘 **Descripción General**

En esta práctica se ha montado una infraestructura **de dos niveles** utilizando **Vagrant** y **Debian 12**.  
El objetivo es desplegar una aplicación de **gestión de usuarios** (descargable desde [este enlace](https://informatica.iesalbarregas.com/mod/url/view.php?id=4382)) sobre una arquitectura compuesta por:

- 🖥️ **Servidor Apache/PHP:** encargado de servir la aplicación web.  
- 🗄️ **Servidor MySQL:** donde reside la base de datos de la aplicación.

Ambas máquinas se crean y configuran automáticamente mediante **scripts de aprovisionamiento en Bash**.



## 🗂️ **Estructura del Repositorio**


🗂️ Estructura del Repositorio
.
├── Vagrantfile
├── provisioning/
│   ├── apache_provision.sh
│   └── mysql_provision.sh
├── README.md
└── media/
    ├── captura_apache.png
    ├── captura_mysql.png
    └── screencast_funcionamiento.mp4

## ⚙️ **Configuración del Entorno con Vagrant**

### 🔧 Requisitos Previos

- [Vagrant](https://developer.hashicorp.com/vagrant/downloads)  
- [VirtualBox](https://www.virtualbox.org/)  


---


### 🧩 **Estructura de la Infraestructura**

| Máquina          | Rol                               | Hostname        | Red             | Acceso a Internet | Puerto local |
|------------------|------------------------------------|-----------------|-----------------|------------------|---------------|
| `AntonioApache`  | Servidor Web (Apache + PHP)        | `antonioapache` | NAT + Privada   | ✅ (solo NAT)     | `8080 → 80`   |
| `AntonioMysql`   | Servidor de Base de Datos (MySQL)  | `antoniomysql`  | Privada         | ❌                | —             |

---

🧱 Fichero Vagrantfile
  ### Máquina 1: Apache y Máquina 2: MySQL
  ```ruby
config.vm.define "MarioApache" do |apache|
    apache.vm.box = "debian/bookworm64"
    apache.vm.hostname = "MarioApache"
    apache.vm.network "forwarded_port", guest: 80, host: 8080
    apache.vm.network "private_network", ip: "192.168.33.10"
    apache.vm.provision "shell", path: "Apache.sh"
    apache.vm.network "public_network", bridge: "enp0s3"
  end


  config.vm.define "MarioMysql" do |mysql|
    mysql.vm.box = "debian/bookworm64"
    mysql.vm.hostname = "MarioMysql"
    mysql.vm.network "forwarded_port", guest: 3306, host: 8088
    mysql.vm.network "forwarded_port", guest: 80, host: 8089
    mysql.vm.network "private_network", ip: "192.168.33.11"
    mysql.vm.provision "shell", path: "Mysql.sh"
  end

```

### 🖥️  Scripts de Aprovisionamiento

### 🔹 Apache.sh
 ```ruby
#!/bin/bash
# Actualizar paquetes del sistema
sudo apt update -y && sudo apt upgrade -y

# Instalar Apache y PHP
sudo apt install -y apache2 php libapache2-mod-php php-mysql unzip

# Habilitar Apache y arrancar el servicio
sudo systemctl enable apache2
sudo systemctl start apache2

# Descargar y desplegar la aplicación de gestión de usuarios
sudo wget -O app.zip https://informatica.iesalbarregas.com/mod/url/view.php?id=4382 
sudo unzip app.zip -d /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo systemctl restart apache2
echo "✅ Servidor Apache configurado y aplicación desplegada correctamente."
```

### 📘 Explicación del script:

Actualiza el sistema y paquetes.

Instala el servidor web Apache y PHP.

Descarga la aplicación y la descomprime en el directorio web.

Configura permisos para el usuario de Apache.

Inicia el servicio automáticamente.

### 🔹 Mysql.sh
 ```ruby
#!/bin/bash

# Actualizar repositorios e instalar MariaDB
sudo apt update
sudo apt install -y mariadb-server

#quita la conexion a internet
sudo ip route del default

# Habilitar y arrancar el servicio (puede llamarse mysql en algunas versiones)
sudo systemctl enable mariadb || systemctl enable mysql
sudo systemctl start mariadb || systemctl start mysql

# Crear base de datos y usuario
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'Antonio'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'Antonio'@'%';
FLUSH PRIVILEGES;
EOF
echo "✅ Servidor MySQL configurado y base de datos creada correctamente."
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections

# Instalar phpMyAdmin sin interaccion
sudo apt install -y phpmyadmin

# Habilitar extensiones PHP necesarias
sudo phpenmod mbstring
sudo systemctl restart apache2

# Configurar acceso remoto a phpMyAdmin 
sudo sed -i 's/Require local/Require all granted/' /etc/apache2/conf-available/phpmyadmin.conf
sudo systemctl restart apache2

echo " Instalacion completada. Accede a phpMyAdmin en http://localhost/phpmyadmin "
#Desactiva el internet, activar despues de la descarga
sudo ip route del default

```
### 📘 Explicación del Script

Instala y arranca el servicio MySQL.

Crea la base de datos gestion_usuarios.

Añade el usuario appuser con acceso desde el servidor Apache.

Otorga permisos y aplica los cambios.

### 📸 Evidencias de Funcionamiento

✅ Servidor Apache

✅ Servidor MySQL
