FROM alpine:edge
MAINTAINER Etopian Inc. <contact@etopian.com>

LABEL   devoply.type="site" \
        devoply.cms="wordpress" \
        devoply.framework="wordpress" \
        devoply.language="php7" \
        devoply.require="mariadb etopian/nginx-proxy" \
        devoply.recommend="redis" \
        devoply.description="WordPress on Nginx and PHP-FPM with WP-CLI." \
        devoply.name="WordPress" \
        devoply.params="docker run -d --name {container_name} -e VIRTUAL_HOST={virtual_hosts} -v /data/sites/{domain_name}:/DATA etopian/alpine-php7-wordpress"



RUN echo 'http://dl-4.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories\
    && apk update \
    && apk add bash less vim nginx ca-certificates \
    php7-fpm php7-json php7-zlib php7-xml php7-pdo php7-phar php7-openssl \
    php7-pdo_mysql php7-mysqli php7-session \
    php7-gd php7-iconv php7-mcrypt \
    php7-curl php7-opcache php7-ctype php7-apcu \
    php7-intl php7-bcmath php7-dom php7-xmlreader mysql-client curl && apk add -u musl

RUN rm -rf /var/cache/apk/*

ENV TERM="xterm" \
    DB_HOST="172.17.0.1" \
    DB_NAME="" \
    DB_USER=""\
    DB_PASS=""


RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/sbin\/nologin/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/bin\/bash/g' /etc/passwd && \
    sed -i 's/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/sbin\/nologin/nginx:x:100:101:Linux User,,,:\/var\/www\/localhost\/htdocs:\/bin\/bash/g' /etc/passwd- && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm

ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php7/
ADD files/run.sh /
RUN chmod +x /run.sh

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp-cli

EXPOSE 80
VOLUME ["/DATA"]

CMD ["/run.sh"]
