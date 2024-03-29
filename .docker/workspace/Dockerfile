FROM phusion/baseimage:focal-1.0.0

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

# Set environment variables
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

ENV NVM_DIR /home/crater/.nvm

ENV PUID=1000
ENV PGID=1000

ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}

#RUN groupadd -g ${PGID} crater && \
#    useradd -l -u ${PUID} -g crater -m crater -G docker_env && \
#    usermod -p "*" crater -s /bin/bash && \

# Add the "PHP 8" ppa
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

# Install "PHP Extentions", "libraries", "Software's"
RUN apt-get update && \
    apt-get install -y \
    mariadb-client \
    pkg-config \
    php8.1-bcmath \
    php8.1-cli \
    php8.1-common \
    php8.1-curl \
    php8.1-xml \
    php8.1-imap \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-pcov \
    php8.1-pgsql \
    php8.1-soap \
    php8.1-sqlite \
    php8.1-sqlite3 \
    php8.1-zip \
    php8.1-memcached \
    php8.1-gd \
    php8.1-redis \
    php8.1-dev \
    php8.1-imagick \
    php-pear \
    wget \
    make \
    libaio1 \
    libaio-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libssl-dev \
    libxml2-dev \
    libsqlite3-dev \
    xz-utils \
    sqlite3 \
    git \
    curl \
    nano \
    git \
    zip \
    unzip \
    bash-completion \
    #xvfb gtk2-engines-pixbuf xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable imagemagick x11-apps \
    #locales-all \
    wkhtmltopdf \
    && apt-get clean

# Force the proper PHP version
RUN update-alternatives --set php /usr/bin/php8.1 && \
    update-alternatives --set phar /usr/bin/phar8.1 && \
    update-alternatives --set phar.phar /usr/bin/phar.phar8.1

RUN pecl install xdebug;

# Copy xdebug configuration for remote debugging
COPY ./xdebug.ini /etc/php/8.1/cli/conf.d/20-xdebug.ini
COPY ./php.ini /etc/php/8.1/cli/php.ini

# Add a non-root user to prevent files being created with root permissions on host machine.
RUN groupadd -g $PGID crater \
    && useradd -u $PUID -g crater -m crater \
    && mkdir -p /home/crater/xdebug;

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Composer for Laravel/Codeigniter
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Install nvm (A Node Version Manager)
USER crater
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.3/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install 18 && \
    nvm install 20 && \
    nvm use 18 && \
    nvm alias default 18

# Wouldn't execute when added to the RUN statement in the above block
# Source NVM when loading bash since ~/.profile isn't loaded on non-login shell
RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc && \
    echo "export PS1='\W\$ '" >> ~/.bashrc
# Add NVM binaries to root's .bashrc
USER root
RUN echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="/home/crater/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

#Install Yarn
USER crater
RUN [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    curl -o- -L https://yarnpkg.com/install.sh | bash; \
    echo "" >> ~/.bashrc && \
    echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc

# Add Yarn binaries to root's .bashrc
USER root
RUN echo "" >> ~/.bashrc && \
    echo 'export YARN_DIR="/home/crater/.yarn"' >> ~/.bashrc && \
    echo 'export PATH="$YARN_DIR/bin:$PATH"' >> ~/.bashrc

# Copy artisan autocompleter to the proper folder
#COPY ./artisan-autocompletion.sh /etc/bash_completion.d/artisan

# Add an artisan alias to .bashrc
RUN echo "" >> /home/crater/.bashrc && \
    echo 'alias artisan="php artisan"' >> /home/crater/.bashrc

RUN echo "export PS1='\W\$ '" >> /etc/profile

# Clean up
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default work directory
WORKDIR /var/www/projects
