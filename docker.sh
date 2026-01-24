#!/bin/bash

set -eu

echo?() {
	$1 >/dev/null 2>&1 && echo "${@:2}"
}

exec docker run -it \
	-v "$(pwd)"/binpkgs:/var/cache/binpkgs \
	-v "$(pwd)":/etc/portage \
	-v /tmp:/tmp \
	-v /var/cache/distfiles:/var/cache/distfiles \
	-v /var/cache/edb:/var/cache/edb \
	-v /var/db/repos:/var/db/repos \
	--tmpfs /var/tmp:exec \
	$(echo? nvidia-smi --gpus all) \
	${IMAGE-gentoo-yamad} ${@-bash}
