# Usamos una imagen que incluye Apache y PHP 8.0
FROM php:8.0-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    libonig-dev \
    libzip-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configurar y instalar las extensiones de PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Copiar el proyecto al contenedor
COPY . /var/www/html

# Instalar las dependencias del proyecto con Composer
RUN composer install --optimize-autoloader --no-dev

# Habilitar mod_rewrite para Laravel
RUN a2enmod rewrite

# Copiar un archivo de configuración de Apache personalizado para Laravel (deberás crear este archivo)
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Cambiamos el propietario de los directorios a www-data
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/storage
RUN chmod -R 775 /var/www/html/bootstrap/cache

# Exponer el puerto 80
EXPOSE 80

# Añadir un script para cambiar los permisos y luego iniciar Apache
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
