#!/bin/bash

# Habilitamos el modo de shell para mostrar los comandos que se ejecutan
set -x

# Actualizamos la lista de paquetes
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos los módulos necesarios
apt install php-fpm php-mysql -y

# Configuración de php-fpm
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix.pathinfo=0/" /etc/php/7.4/fpm/php.ini

# Reiniciamos el servicio de php-fpm
systemctl restart php7.4-fpm

# Configuramos el archivo de php para que escuche en el puerto 9000
sed -i "s#/run/php/php7.4-fpm.sock#9000#" /etc/php/7.4/fpm/pool.d/www.conf

# Reiniciamos el servicio de php-fpm
systemctl restart php7.4-fpm