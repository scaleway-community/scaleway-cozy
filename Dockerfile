## -*- docker-image-name: "scaleway/cozy:latest" -*-
FROM scaleway/ubuntu:vivid
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install Cozy tools and dependencies.
RUN apt-get update \
 && apt-get upgrade -y \
 && curl -sL https://deb.nodesource.com/setup | sudo bash -

RUN apt-get install -y --force-yes \
     python \
     openssl \
     git \
     imagemagick \
     curl \
     wget \
     sqlite3 \
     build-essential \
     python-dev \
     python-setuptools \
     python-pip \
     libssl-dev \
     libicu-dev \
     libcurl4-openssl-dev \
     erlang \
     couchdb \
     postfix \
     pwgen \
     nginx \
     nodejs

RUN pip install \
      supervisor \
      virtualenv \
      cozy-indexer

# Install CoffeeScript, Cozy Monitor and Cozy Controller via NPM.
RUN npm install -g \
      coffee-script \
      cozy-controller \
      cozy-monitor

RUN useradd -M cozy \
 && useradd -M cozy-data-system \
 && useradd -M cozy-home

RUN mkdir /etc/cozy \
 && chown -hR cozy /etc/cozy

ADD patches/etc /etc/

# Configure Supervisor.
RUN mkdir -p /var/log/supervisor \
 && mkdir -p /etc/supervisor/conf.d/ \
 && chmod 777 /var/log/supervisor
RUN chmod 0644 /etc/supervisor/conf.d/*

# Configure Couchdb
RUN mkdir -p /var/run/couchdb \
 && chown -R couchdb: /var/lib/couchdb \
 && chown -R couchdb: /var/log/couchdb \
 && chown -R couchdb: /var/run/couchdb \
 && chown -R couchdb: /etc/couchdb \
 && chmod 0770 /var/lib/couchdb/ \
 && chmod 0770 /var/log/couchdb/ \
 && chmod 0770 /var/run/couchdb/ \
 && chmod 664 /etc/couchdb/*.ini \
 && chmod 664 /etc/couchdb/local.d/*.ini \
 && chmod 775 /etc/couchdb/*.d


RUN supervisord -c /etc/supervisord.conf \
 && sleep 5 \
 && cozy-monitor install data-system \
 && cozy-monitor install home \
 && cozy-monitor install proxy

ADD patches/cozy-init /etc/init.d/

# Install Cozy Indexer.
RUN mkdir -p /usr/local/cozy-indexer \
 && cd /usr/local/cozy-indexer \
 && git clone https://github.com/cozy/cozy-data-indexer.git \
 && cd /usr/local/cozy-indexer/cozy-data-indexer \
 && virtualenv --quiet /usr/local/cozy-indexer/cozy-data-indexer/virtualenv \
 && . ./virtualenv/bin/activate \
 && pip install -r /usr/local/cozy-indexer/cozy-data-indexer/requirements/common.txt \
 && chown -R cozy:cozy /usr/local/cozy-indexer


RUN rm /etc/nginx/sites-enabled/default \
 && ln -s /etc/nginx/sites-available/cozy /etc/nginx/sites-enabled/cozy
RUN nginx -t

# Configure Postfix with default parameters.
# TODO: Change mydomain.net?
RUN echo "postfix postfix/mailname string mydomain.net" | debconf-set-selections \
 && echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections \
 && echo "postfix postfix/destinations string mydomain.net, localhost.localdomain, localhost " | debconf-set-selections \
 && postfix check

RUN systemctl disable couchdb
RUN systemctl disable postfix
RUN systemctl disable nginx
RUN systemctl enable supervisord

# Clean APT cache for a lighter image.
RUN apt-get clean \
 && rm -fr /var/lib/{apt,dpkg,cache,log}

#EXPOSE 80 443

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
