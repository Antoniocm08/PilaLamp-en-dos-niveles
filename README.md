## 🧱 **Pila LAMP en Dos Niveles**
### 🚀 Práctica: Despliegue de Aplicación en Infraestructura de Dos Niveles con Vagrant

----

## 📘 **Descripción General**

En esta práctica se ha montado una infraestructura **de dos niveles** utilizando **Vagrant** y **Debian 12**.  
El objetivo es desplegar una aplicación de **gestión de usuarios** (descargable desde [este enlace](https://informatica.iesalbarregas.com/mod/url/view.php?id=4382)) sobre una arquitectura compuesta por:

- 🖥️ **Servidor Apache/PHP:** encargado de servir la aplicación web.  
- 🗄️ **Servidor MySQL:** donde reside la base de datos de la aplicación.

Ambas máquinas se crean y configuran automáticamente mediante **scripts de aprovisionamiento en Bash**.

---

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
- Git instalado y configurado  


---

### 🧩 **Estructura de la Infraestructura**

| Máquina          | Rol                               | Hostname        | Red             | Acceso a Internet | Puerto local |
|------------------|------------------------------------|-----------------|-----------------|------------------|---------------|
| `AntonioApache`  | Servidor Web (Apache + PHP)        | `antonioapache` | NAT + Privada   | ✅ (solo NAT)     | `8080 → 80`   |
| `AntonioMysql`   | Servidor de Base de Datos (MySQL)  | `antoniomysql`  | Privada         | ❌                | —             |

---

🧱 Fichero Vagrantfile
Vagrant.configure("2") do |config|
  # Máquina 1: Apache
  config.vm.define "AntonioApache" do |apache|
    apache.vm.box = "debian/bookworm64"
    apache.vm.hostname = "Antonioapache"
    apache.vm.network "forwarded_port", guest: 80, host: 8080
    apache.vm.network "private_network", ip: "192.168.56.10"
    apache.vm.provision "shell", path: "apache.sh"
  end

  # Máquina 2: MySQL
  config.vm.define "AntonioMysql" do |mysql|
    mysql.vm.box = "debian/bookworm64"
    mysql.vm.hostname = "Antoniomysql"
    mysql.vm.network "private_network", ip: "192.168.56.11"
    mysql.vm.provision "shell", path: "mysql.sh"
   
  end
end

🖥️ Scripts de Aprovisionamiento
🔹 Apache.sh

#!/bin/bash
# Actualizar paquetes del sistema
sudo apt update -y && sudo apt upgrade -y

# Instalar Apache y PHP
sudo apt install -y apache2 php libapache2-mod-php php-mysql unzip

# Habilitar Apache y arrancar el servicio
sudo systemctl enable apache2
sudo systemctl start apache2

# Descargar y desplegar la aplicación de gestión de usuarios
sudo wget https://informatica.iesalbarregas.com/mod/url/view.php?id=4382 -O app.zip
sudo unzip app.zip -d app
sudo chown -R www-data:www-data /var/www/html/app

echo "✅ Servidor Apache configurado y aplicación desplegada correctamente."

📘 Explicación del script:

Actualiza el sistema y paquetes.

Instala el servidor web Apache y PHP.

Descarga la aplicación y la descomprime en el directorio web.

Configura permisos para el usuario de Apache.

Inicia el servicio automáticamente.

🔹 Mysql.sh

#!/bin/bash
# Actualizar el sistema
sudo apt update -y && sudo apt upgrade -y

# Instalar MySQL Server
sudo apt install -y mysql-server

# Habilitar y arrancar el servicio
sudo systemctl enable mysql
sudo systemctl start mysql

# Crear base de datos y usuario para la aplicación
sudo mysql -e "CREATE DATABASE gestion_usuarios;"
sudo mysql -e "CREATE USER 'appuser'@'192.168.56.10' IDENTIFIED BY 'app1234';"
sudo mysql -e "GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'appuser'@'192.168.56.10';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Servidor MySQL configurado y base de datos creada correctamente."

📘 Explicación del Script

Instala y arranca el servicio MySQL.

Crea la base de datos gestion_usuarios.

Añade el usuario appuser con acceso desde el servidor Apache.

Otorga permisos y aplica los cambios.

📸 Evidencias de Funcionamiento
✅ Servidor Apache

✅ Servidor MySQL
