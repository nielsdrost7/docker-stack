FROM php:8.1-fpm

#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    mariadb-client \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    nano \
    zip \
    unzip \
    libzip-dev \
    libmagickwand-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN pecl install imagick \
#    && docker-php-ext-enable imagick

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug;

#COPY ./fpm.conf /usr/local/etc/php-fpm.d/zzz-crater.fpm.conf

# Copy xdebug configuration for remote debugging
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./php.ini /usr/local/etc/php/php.ini

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add a non-root user to prevent files being created with root permissions on host machine.
#RUN groupadd -g $PGID crater && \
#    useradd -u $PUID -g crater -m crater

# Set the proper permissions
RUN usermod -u 1000 www-data
# Create system user to run Composer and Artisan Commands
#RUN useradd -G www-data,root -u 1000 -d /home/crater crater \
#    && mkdir -p /home/crater/.composer \
    #&& mkdir -p /var/www/projects \
#    && chown -R crater:crater /home/crater

RUN echo "export PS1='\W\$ '" >> /etc/profile

#RUN chown -R crater:crater /var/www/projects
#RUN chown -R $(whoami):$(whoami) /var/log/
#RUN chmod -R 775 /var/www/projects/crater/storage/framework/ /var/www/projects/crater/storage/logs/ /var/www/projects/crater/bootstrap/cache/
# Set the proper permissions

USER root
# Cleanup all downloaded packages
RUN apt-get -y autoclean && apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/*

USER www-data

WORKDIR /var/www/projects

CMD ["php-fpm"]

EXPOSE 9000
