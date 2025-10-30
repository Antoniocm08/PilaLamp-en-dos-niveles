# PilaLamp-en-dos-niveles
🚀 Práctica: Despliegue de Aplicación en Infraestructura de Dos Niveles con Vagrant
📘 Descripción General

En esta práctica se ha montado una infraestructura de dos niveles utilizando Vagrant y Debian 12.
El objetivo es desplegar una aplicación de gestión de usuarios (descargable desde este enlace
) sobre una arquitectura compuesta por:

Servidor Apache/PHP: encargado de servir la aplicación web.

Servidor MySQL: donde reside la base de datos de la aplicación.

Ambas máquinas se crean y configuran de forma automática mediante scripts de aprovisionamiento en Bash.

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
    
⚙️ Configuración del Entorno con Vagrant
1. Requisitos Previos

Vagrant

VirtualBox

Git instalado y configurado

Repositorio público en GitHub creado para este proyecto

. Estructura de la Infraestructura
Máquina	Rol	Hostname	Red	Acceso a Internet	Puerto local
AntonioApache	Servidor Web (Apache + PHP)	carlosgonzapache	NAT + Privada	✅ (solo NAT)	8080 → 80
CarlosGonzMysql	Servidor de Base de Datos (MySQL)	carlosgonzmysql	Privada	❌	—
