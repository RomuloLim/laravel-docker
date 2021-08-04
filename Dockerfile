FROM php:7.4-apache

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN ln -s ./application /var/www/html

USER root

WORKDIR /var/www/html

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

RUN apt-get install curl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

RUN apt install sudo
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt-get update && apt-get install -y nodejs

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd

CMD npm install

EXPOSE 2222 80


ENTRYPOINT ["entrypoint/entrypoint.sh"]