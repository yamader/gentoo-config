#!/bin/bash

set -eu

echo?() {
	$1 >/dev/null 2>&1 && echo "${@:2}"
}

profile="$(pwd)":/etc/portage
if [ "${1-}" = '-r' ]; then
	profile="$(pwd)"/repos.conf:/etc/portage/repos.conf
	shift
fi

exec docker run -it \
	-v "$(pwd)"/binpkgs:/var/cache/binpkgs \
	-v "$profile" \
	-v /tmp:/tmp \
	-v /var/cache/distfiles:/var/cache/distfiles \
	-v /var/cache/edb:/var/cache/edb \
	-v /var/db/repos:/var/db/repos \
	--tmpfs /var/tmp:exec \
	$(echo? nvidia-smi --gpus all) \
	${IMAGE-gentoo-yamad} ${@-bash}
