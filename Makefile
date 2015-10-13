NAME =			cozy
VERSION =		latest
VERSION_ALIASES =	
TITLE =			Cozy
DESCRIPTION =		Cozy
SOURCE_URL =		https://github.com/scaleway-community/scaleway-cozy
VENDOR_URL =		http://cozy.io/

IMAGE_VOLUME_SIZE =	150G
IMAGE_BOOTSCRIPT =	latest
IMAGE_NAME =		Cozy Cloud

# Forward ports
#SHELL_DOCKER_OPTS ?=    -p 80:80 -p 443:443


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
