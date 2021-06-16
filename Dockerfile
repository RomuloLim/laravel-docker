FROM php:7.4-apache

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"


USER root

WORKDIR /var/www/html

COPY  ./application /var/www/html \
      ./.docker/vhost.conf /etc/apache2/sites-enabled/000-default.conf \
      ./.docker/entrypoint /var/www/html/entrypoint \
      ./docker/php/php.ini /usr/local/etc/php/php.ini

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libpq-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    zip \
    curl \
    unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install zip \
    && docker-php-source delete

# cria o diretório de logs para o Supervisor
RUN mkdir /var/log/webhook

# copia os arquivos de configuração do Supervisor
COPY ./.docker/supervisor/conf.d /etc/supervisor/conf.d


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# copia o entreypoint
COPY ./.docker/entrypoint /var/www/entrypoint

# informa o Entrypoint
ENTRYPOINT [ "/var/www/entrypoint/entrypoint.sh" ]
