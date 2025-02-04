FROM wyveo/nginx-php-fpm:php74
WORKDIR /usr/share/nginx/
COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
RUN rm -rf /usr/share/ngix/html
COPY ./application /usr/share/nginx
RUN chmod -R 775 storage/*
RUN ln -s public html