FROM centos:7

MAINTAINER KeepWalking86

#Installing repo epel, webstatic
RUN yum -y install epel-release && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#Installing PHP7
RUN yum install -y php71w php71w-common php71w-gd php71w-phar \
    php71w-xml php71w-cli php71w-mbstring php71w-tokenizer \
    php71w-openssl php71w-pdo php71w-devel \
    php71w-opcache php71w-pear php71w-fpm php71w-pecl-mongodb
#Install PHP Composer
RUN curl -sS https://getcomposer.org/installer |php -- --install-dir=/usr/bin --filename=composer

#Apply PHP configuration
COPY etc/www.conf /etc/php-fpm.d/
COPY etc/opcache.ini /etc/php.d/

###Installing & Configuring Nginx
RUN yum install -y nginx
COPY etc/nginx.conf /etc/nginx/

#Configure vhost for Laravel
RUN mkdir /etc/nginx/sites-enabled
COPY sites-enabled/example.conf /etc/nginx/sites-enabled/

#Install Laravel
RUN yum -y install unzip && mkdir /var/www/example && cd /var/www/example
#RUN composer create-project laravel/laravel /var/www/example/
RUN chown -R nginx:nginx /var/www/example

#Installing & configuring MongoDB-3X
COPY etc/mongodb.repo /etc/yum.repos.d/
RUN yum update -y
RUN yum install mongodb-org -y
#Create DB storage
RUN mkdir -p /data/db && chown -R mongod:mongod /data
#Copy a new configuration file from current directory
COPY etc/mongod.conf /etc/

#Installing & Configuring Supervisord
RUN yum -y install python-setuptools
RUN easy_install supervisor
COPY etc/supervisord.conf /etc/supervisord.conf
# Set the default command to execute
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]

##Clearing the yum Caches
RUN yum clean all

## Expose ports
EXPOSE 80 9000 27017
