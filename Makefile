NAME =			cozy
VERSION =		latest
VERSION_ALIASES =	
TITLE =			Cozy Cloud
DESCRIPTION =		Cozy Cloud
SOURCE_URL =		https://github.com/scaleway-community/scaleway-cozy
VENDOR_URL =		http://cozy.io/
DEFAULT_IMAGE_ARCH =	x86_64

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT = latest
IMAGE_NAME =		Cozy Cloud (beta)

# Forward ports
#SHELL_DOCKER_OPTS ?=    -p 80:80 -p 443:443


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - https://j.mp/scw-builder | bash
-include docker-rules.mk
