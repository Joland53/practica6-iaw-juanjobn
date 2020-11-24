#!/bin/bash

# Habilitamos el modo de shell para mostrar los comandos que se ejecutan
set -x

# Actualizamos la lista de paquetes
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos nginx
apt install nginx -y

# Instalamos los módulos necesarios
apt install php-fpm php-mysql -y

# Configuración de php-fpm
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix.pathinfo=0/" /etc/php/7.4/fpm/php.ini

# Reiniciamos el servicio de php-fpm
systemctl restart php7.4-fpm

#Copiamos el archivo de configuración de Nginx
cp default /etc/nginx/sites-available/

# Reiniciamos el servicio de Nginx
systemctl restart nginx

# Copiamos archivo index.php
cp index.php /var/www/html
