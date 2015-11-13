## -*- docker-image-name: "scaleway/cozy:latest" -*-
FROM scaleway/ubuntu:trusty
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install Cozy tools and dependencies.
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --force-yes ca-certificates apt-transport-https binutils \
	build-essential coffeescript cpp cpp-4.8 \
	dpkg-dev erlang-asn1 erlang-base erlang-crypto erlang-eunit erlang-inets \
	erlang-mnesia erlang-os-mon erlang-public-key erlang-runtime-tools erlang-snmp \
	erlang-ssl erlang-syntax-tools erlang-tools erlang-webtool erlang-xmerl \
	fakeroot fontconfig fontconfig-config fonts-dejavu-core g++ g++-4.8 gcc gcc-4.8 \
	geoip-database ghostscript git git-man gsfonts gyp hicolor-icon-theme \
	imagemagick imagemagick-common javascript-common libalgorithm-diff-perl \
	libalgorithm-diff-xs-perl libalgorithm-merge-perl libasan0 libatomic1 \
	libavahi-client3 libavahi-common-data libavahi-common3 libc-ares-dev libc-ares2 \
	libc-dev-bin libc6-dev libcairo2 libcloog-isl4 libcroco3 libcups2 \
	libcupsfilters1 libcupsimage2 libdatrie1 libdjvulibre-text libdjvulibre21 \
	libdpkg-perl liberror-perl libexpat1-dev libfakeroot libfftw3-double3 \
	libfile-fcntllock-perl libfontconfig1 libfreetype6 libgcc-4.8-dev libgd3 \
	libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgeoip1 libgmp10 libgomp1 \
	libgraphite2-3 libgs9 libgs9-common libharfbuzz0b libicu52 libijs-0.35 \
	libilmbase6 libisl10 libjasper1 libjbig0 libjbig2dec0 libjpeg-turbo8 libjpeg8 \
	libjs-node-uuid liblcms2-2 liblqr-1-0 libltdl7 libmagickcore5 \
	libmagickcore5-extra libmagickwand5 libmozjs185-1.0 libmpc3 libmpfr4 \
	libmysqlclient18 libnetpbm10 libnspr4 libopenexr6 libpango-1.0-0 \
	libpangocairo-1.0-0 libpangoft2-1.0-0 libpaper-utils libpaper1 libpixman-1-0 \
	libpython-dev libpython2.7-dev librsvg2-2 librsvg2-common libsctp1 libssl-dev \
	libssl-doc libstdc++-4.8-dev libthai-data libthai0 libtiff5 libtimedate-perl \
	libv8-3.14-dev libv8-3.14.5 libvpx1 libwmf0.2-7 libxcb-render0 libxcb-shm0 \
	libxml2-dev libxpm4 libxrender1 libxslt1-dev libxslt1.1 linux-libc-dev \
	lksctp-tools manpages manpages-dev mysql-common netpbm nginx nginx-common \
	nginx-core node-abbrev node-ansi node-archy node-async node-block-stream \
	node-combined-stream node-cookie-jar node-delayed-stream node-forever-agent \
	node-form-data node-fstream node-fstream-ignore node-github-url-from-git \
	node-glob node-graceful-fs node-gyp node-inherits node-ini \
	node-json-stringify-safe node-lockfile node-lru-cache node-mime node-minimatch \
	node-mkdirp node-mute-stream node-node-uuid node-nopt \
	node-normalize-package-data node-npmlog node-once node-osenv node-qs node-read \
	node-read-package-json node-request node-retry node-rimraf node-semver node-sha \
	node-sigmund node-slide node-tar node-tunnel-agent node-which nodejs nodejs-dev \
	nodejs-legacy npm patch poppler-data postfix pwgen python-colorama \
	python-dateutil python-dev python-distlib python-html5lib python-meld3 \
	python-mysqldb python-pip python-pkg-resources python-pycurl python-setuptools \
	python-software-properties python-tornado python-virtualenv python-whoosh \
	python2.7-dev sqlite3 ssl-cert supervisor zlib1g-dev && \
	apt-get clean

RUN wget -O - http://ubuntu.cozycloud.cc/cozy.gpg.key 2>/dev/null | apt-key add - && \
	echo 'deb http://ubuntu.cozycloud.cc/debian trusty main' > /etc/apt/sources.list.d/cozy.list && \
	apt-get update ; \
	apt-get update && \
	apt-get install -y --force-yes cozy-indexer && \
	apt-get install --download-only cozy couchdb couchdb-bin couchdb-common

# Clean APT cache for a lighter image.
RUN apt-get clean \
 && rm -fr /var/lib/{apt,dpkg,cache,log}

#EXPOSE 80 443

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
