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


# Install Cozy tools and dependencies.
RUN apt-get update      \
 && apt-get upgrade -y  \
 && apt-get clean


# Install Cozy
RUN wget -O - http://ubuntu.cozycloud.cc/cozy.gpg.key 2>/dev/null | apt-key add -                 \
 && echo 'deb http://ubuntu.cozycloud.cc/debian trusty cozy' > /etc/apt/sources.list.d/cozy.list  \
 && apt-get update; apt-get update                                                                \
 && apt-get install -y --force-yes python-cozy-management cozy-apt-key cozy-apt-list              \
 && cozy_management install_requirements                                                          \
 && apt-get clean


# Patch rootfs
COPY ./overlay/ /


# Export port for container-based runtime
EXPOSE 80 443


# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
