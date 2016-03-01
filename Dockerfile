## -*- docker-image-name: "scaleway/cozy:latest" -*-
FROM scaleway/ubuntu:trusty
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install Cozy tools and dependencies.
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get clean

RUN wget -O - http://ubuntu.cozycloud.cc/cozy.gpg.key 2>/dev/null | apt-key add - \
 && echo 'deb http://ubuntu.cozycloud.cc/debian trusty cozy' > /etc/apt/sources.list.d/cozy.list \
 && apt-get update; apt-get update \
 && apt-get install -y --force-yes python-cozy-management cozy-apt-key cozy-apt-list \
 && cozy_management install_requirements \
 && apt-get clean

ADD patches/etc/ /etc

#EXPOSE 80 443

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
