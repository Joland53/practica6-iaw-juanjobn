# IAW - LEMP Stack
## Instalación del servidor web Nginx
```
sudo apt update
sudo apt install nginx
```
## Instalación de php-fpm y php-mysql
```
sudo apt install php-fpm
sudo apt install php-mysql
```

## Configuración de Nginx para comunicarse con php-fpm a través de un socket UNIX
En esta sección vamos a explicar cómo podemos configurar Nginx para que pueda comunicarse con el proceso php-fpm a través de un socket UNIX.

Editamos el archivo de configuración /etc/nginx/sites-available/default:

```
sudo nano /etc/nginx/sites-available/default
```
Realizamos los siguientes cambios:

En la sección index añadimos el valor index.php en primer lugar para que darle prioridad respecto a los archivos index.html.
Añadimos el bloque location ~ \.php$ indicando dónde se encuentra el archivo de configuración fastcgi-php.conf y el archivo php7.4-fpm.sock.
Opcionalmente podemos añadir el bloque location ~ /\.ht para no permitir que un usuario pueda descargar los archivos .htaccess. Estos archivos no son procesados por Nginx, son específicos de Apache.

Podemos comprobar que la sintaxis del archivo de configuración es correcta con el comando:
```
sudo ngingx -t
```
Una vez realizados los cambios reiniciamos el servicio nginx:
```
sudo systemctl restart nginx
```
 ## Comprobar que la instalación se ha realizado correctamente
Crea un archivo llamado info.php en el directorio /var/www/html.
```
sudo nano /var/www/html/info.php
```

Añade el siguiente contenido:

```
<?php

phpinfo();

?>
```
## Configuración de Nginx para comunicarse con php-fpm a través de un socket TCP/IP

Configuración de php-fmp
En primer lugar hay que modificar la directiva listen del archivo /etc/php/7.4/fpm/pool.d/www.conf.

```
sudo nano /etc/php/7.4/fpm/pool.d/www.conf
```

Si buscamos la directiva listen en el archivo de configuración nos encontramos que en la configuración por defecto está escuchando en el socket UNIX /run/php/php7.4-fpm.sock. A continuación se muestra un fragmento del archivo de configuración por defecto que hace referencia a la directiva listen.

```
; The address on which to accept FastCGI requests.
; Valid syntaxes are:
;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific IPv4 address on
;                            a specific port;
;   '[ip:6:addr:ess]:port' - to listen on a TCP socket to a specific IPv6 address on
;                            a specific port;
;   'port'                 - to listen on a TCP socket to all addresses
;                            (IPv6 and IPv4-mapped) on a specific port;
;   '/path/to/unix/socket' - to listen on a unix socket.
; Note: This value is mandatory.
listen = /run/php/php7.4-fpm.sock
```

Habrá que modificar la directiva listen por la dirección de localhost (127.0.0.1) y un puerto. En este ejemplo utilizaremos el puerto 9000. La directiva listen quedaría así:
```
listen = 127.0.0.1:9000
```
Una vez que hemos realizado las modificaciones en la configuración reiniciamos el servicio de php-fpm para que se apliquen los cambios:
```
sudo systemctl restart php7.4-fpm
```
## Configuración de Nginx
En este caso hay que configurar en el archivo /etc/nginx/sites-available/default que los scripts PHP se van a enviar al servidor FastCGI a través de un socket TCP/IP.

```
sudo nano /etc/nginx/sites-available/default
```

Habrá que modificar la directiva de configuración fastcgi_pass para indicar la dirección y el puerto donde se encuentra el servidor FastCGI. Por ejemplo, si el servidor FastCGI se está ejecutando en la misma máquina (127.0.0.1), en el puerto 9000 habrá que asignarle el siguiente valor:
```
fastcgi_pass 127.0.0.1:9000;
```

Podemos comprobar que la sintaxis del archivo de configuración es correcta con el comando:

sudo ngingx -t
Una vez realizados los cambios reiniciamos el servicio nginx:

sudo systemctl restart nginx

## Configuración de la directiva cgi.fix_pathinfo para mejorar la seguridad
Es recomendable realizar un cambio en la directiva de configuración cgi.fix_pathinfo por cuestiones de seguridad. Editamos el siguiente archivo de configuración:
```
sudo nano /etc/php/7.4/fpm/php.ini
```
Buscamos la directiva de configuración cgi.fix_pathinfo que por defecto aparece comentada con un punto y coma y con un valor igual a 1.
```
;cgi.fix_pathinfo=1
```
Eliminamos el punto y coma y la configuramos con un valor igual a 0.
```
cgi.fix_pathinfo=0
```
Una vez modificado el archivo de configuración y guardados los cambios reiniciamos el servicio php7.4-fpm.
```
sudo systemctl restart php7.4-fpm
```
