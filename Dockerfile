FROM php:7.4-apache

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql pdo_pgsql opcache

RUN a2enmod rewrite

ENV DRUPAL_VERSION 9.3.0
RUN curl -fSL "https://www.drupal.org/download-latest/tar.gz" -o drupal.tar.gz \
    && tar -xz --strip-components=1 -f drupal.tar.gz \
    && rm drupal.tar.gz

COPY settings.php sites/default/

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/sites/default

EXPOSE 80
CMD ["apache2-foreground"]