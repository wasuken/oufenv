FROM php:7.4-apache

RUN apt-get update && apt-get install -y python3

RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev \
	&& docker-php-ext-install pdo_mysql mysqli gd iconv \
	&& pecl install mcrypt-1.0.3 libonig-dev \
	&& docker-php-ext-enable mcrypt


RUN apt-get install -y git-core curl build-essential openssl libssl-dev

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get install --yes nodejs


RUN cd /usr/bin && curl -s http://getcomposer.org/installer | php && ln -s /usr/bin/composer.phar /usr/bin/composer

RUN apt-get update \
	&& apt-get install -y \
	git \
	zip \
	unzip \
	vim \
	libpng-dev \
	libpq-dev \
	&& docker-php-ext-install pdo_mysql

RUN apt-get install -y libicu-dev libxml2-dev libcurl4-openssl-dev

RUN	docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
	docker-php-ext-install intl json mysqli xml curl opcache

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mv /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
RUN /bin/sh -c a2enmod rewrite

EXPOSE 80

COPY ./php.ini /usr/local/etc/php/
ADD 000-default.conf /etc/apache2/sites-enabled/

CMD ["apache2-foreground"]
