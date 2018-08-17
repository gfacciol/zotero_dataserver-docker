FROM debian:wheezy-backports
MAINTAINER Gabriele Facciolo <gfacciol@gmail.com>
# Following http://git.27o.de/dataserver/about/Installation-Instructions-for-Debian-Wheezy.md

# debian packages
RUN apt-get update && apt-get install -y \
    apache2 libapache2-mod-php5 mysql-server memcached zendframework php5-cli php5-memcached php5-mysql php5-curl \
    apache2 uwsgi uwsgi-plugin-psgi libplack-perl libdigest-hmac-perl libjson-xs-perl libfile-util-perl libapache2-mod-uwsgi libswitch-perl \
    git gnutls-bin runit wget curl net-tools vim build-essential

# Zotero
RUN mkdir -p /srv/zotero/log/upload && \
    mkdir -p /srv/zotero/log/download && \
    mkdir -p /srv/zotero/log/error && \
    mkdir -p /srv/zotero/log/api-errors && \
    mkdir -p /srv/zotero/log/sync-errors && \
    mkdir -p /srv/zotero/dataserver && \
    mkdir -p /srv/zotero/zss && \
    mkdir -p /var/log/httpd/sync-errors && \
    mkdir -p /var/log/httpd/api-errors && \
    chown www-data: /var/log/httpd/sync-errors && \
    chown www-data: /var/log/httpd/api-errors

# Dataserver
RUN git clone --depth=1 git://git.27o.de/dataserver /srv/zotero/dataserver && \
    chown www-data:www-data /srv/zotero/dataserver/tmp
#RUN cd /srv/zotero/dataserver/include && rm -r Zend && ln -s /usr/share/php/libzend-framework-php/Zend
RUN cd /srv/zotero/dataserver/include && rm -r Zend && ln -s /usr/share/php/Zend

#Apache2
#certtool -p --sec-param high --outfile /etc/apache2/zotero.key
#certtool -s --load-privkey /etc/apache2/zotero.key --outfile /etc/apache2/zotero.cert
ADD apache/zotero.key /etc/apache2/
ADD apache/zotero.cert /etc/apache2/
ADD apache/sites-zotero.conf /etc/apache2/sites-available/zotero
ADD apache/dot.htaccess  /srv/zotero/dataserver/htdocs/\.htaccess
RUN a2enmod ssl && \
    a2enmod rewrite && \
    a2ensite zotero

#Mysql
ADD mysql/zotero.cnf /etc/mysql/conf.d/zotero.cnf
ADD mysql/setup_db /srv/zotero/dataserver/misc/setup_db
RUN /etc/init.d/mysql start && \
    mysqladmin -u root password password && \
    cd /srv/zotero/dataserver/misc/ && \
    ./setup_db


# Zotero Configuration
ADD dataserver/dbconnect.inc.php dataserver/config.inc.php /srv/zotero/dataserver/include/config/
ADD dataserver/sv/zotero-download /etc/sv/zotero-download
ADD dataserver/sv/zotero-upload   /etc/sv/zotero-upload  
ADD dataserver/sv/zotero-error    /etc/sv/zotero-error   
RUN cd /etc/service && \
    ln -s ../sv/zotero-download /etc/service/ && \
    ln -s ../sv/zotero-upload /etc/service/ && \
    ln -s ../sv/zotero-error /etc/service/ 



# ZSS
RUN git clone --depth=1 git://git.27o.de/zss /srv/zotero/zss && \
    mkdir /srv/zotero/storage && \
    chown www-data:www-data /srv/zotero/storage

ADD zss/zss.yaml /etc/uwsgi/apps-available/
ADD zss/ZSS.pm   /srv/zotero/zss/
ADD zss/zss.psgi /srv/zotero/zss/
RUN ln -s /etc/uwsgi/apps-available/zss.yaml /etc/uwsgi/apps-enabled 
# fix uwsgi init scipt (always fails)
ADD patches/uwsgi /etc/init.d/uwsgi 


## failed attempt to install Zotero Web-Library locally
## not working
#RUN cd /srv/ && \
#    git clone --depth=1 --recursive https://github.com/zotero/web-library.git && \
#    curl -sL https://deb.nodesource.com/setup_4.x | bash - && apt-get install -y nodejs && \
#    cd /srv/web-library && \
#    npm install && \
#    npm install prompt




# replace custom /srv/zotero/dataserver/admin/add_user that allows to write the password
ADD patches/add_user /srv/zotero/dataserver/admin/add_user

# TEST ADD USER: test PASSWORD: test
RUN service mysql start && service memcached start && \
    cd /srv/zotero/dataserver/admin && \
    ./add_user 101 test test && \
    ./add_user 102 test2 test2 && \
    ./add_group -o test -f members -r members -e members testgroup && \
    ./add_groupuser testgroup test2 member 


# docker server startup
EXPOSE 80 443

CMD service mysql start && \
    service uwsgi start && \
    service apache2 start && \
    service memcached start && \
    bash -c "/usr/sbin/runsvdir-start&" && \
    /bin/bash 
