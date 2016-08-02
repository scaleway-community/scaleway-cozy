## -*- docker-image-name: "scaleway/cozy:latest" -*-
FROM scaleway/ubuntu:amd64-trusty
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-trusty       # arch=armv7l
#FROM scaleway/ubuntu:arm64-trusty       # arch=arm64
#FROM scaleway/ubuntu:i386-trusty        # arch=i386
#FROM scaleway/ubuntu:mips-trusty        # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter

RUN echo "APT::Install-Recommends "0"; \nAPT::Install-Suggests "0";" > /etc/apt/apt.conf.d/60recommends

RUN apt-get update &&\
    apt-get dist-upgrade -y &&\
    apt-get install -y apt-transport-https

# Setup external repositories
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - &&\
    echo 'deb https://deb.nodesource.com/node_4.x trusty main' > /etc/apt/sources.list.d/nodesource.list &&\
    curl -s https://ubuntu.cozycloud.cc/cozy.gpg.key | apt-key add - &&\
    echo 'deb https://ubuntu.cozycloud.cc/debian trusty cozy' > /etc/apt/sources.list.d/cozy.list &&\
    apt-get update

# Install Cozy dependencies.
# Yep, we need to change to PreDepends…
RUN apt-get install -y couchdb supervisor postfix nginx &&\
    apt-get install -y cozy-depends cozy-apt-key cozy-apt-list &&\
    apt-get clean

# Patch rootfs
COPY ./overlay/ /

RUN update-rc.d firstboot defaults
RUN rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub

# Export port for container-based runtime
EXPOSE 80 443

# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
