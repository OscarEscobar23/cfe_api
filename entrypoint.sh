#!/bin/bash

# Asegúrate de que www-data es el propietario de los directorios storage y bootstrap/cache
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Dar permisos de escritura a www-data
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Iniciar Apache
exec apache2-foreground
