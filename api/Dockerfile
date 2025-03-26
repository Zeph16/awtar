FROM php:8.4-apache


RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache's mod_rewrite module
RUN a2enmod rewrite

# Allow .htaccess overrides by modifying the Apache config
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN sed -i 's/Listen 80/Listen 0.0.0.0:8000/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8000>/' /etc/apache2/sites-available/000-default.conf

COPY . /var/www/html/

# Set correct ownership
RUN chown -R www-data:www-data /var/www/html

