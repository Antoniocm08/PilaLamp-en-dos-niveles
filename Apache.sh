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

