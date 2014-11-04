FROM debian:stable

# install your application's dependencies
RUN apt-get update
RUN apt-get install -y wget
RUN wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key
RUN apt-key add - < Release.key  
RUN echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud.list 
RUN apt-get update
RUN apt-get install -y owncloud

RUN a2enmod ssl
RUN a2ensite default-ssl
RUN a2enmod rewrite

# Only expose HTTPS by default
# EXPOSE 80
EXPOSE 443

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_RUN_DIR   /etc/apache2

ADD bootstrap.sh /root/
RUN rm /etc/apache2/sites-enabled/*
ADD default-ssl /etc/apache2/sites-enabled/
# config/ is mounted
RUN rm -rf /var/www/owncloud/config/

RUN echo "Redirect 301 /.well-known/carddav /remote.php/carddav" >> /var/www/.htaccess
RUN echo "Redirect 301 /.well-known/caldav /remote.php/caldav" >> /var/www/.htaccess

CMD ["/bin/bash", "/root/bootstrap.sh"]
