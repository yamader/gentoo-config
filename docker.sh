#!/usr/bin/env bash

set -eu

source="https://ftp.jaist.ac.jp/pub/Linux/Gentoo/releases/amd64/autobuilds/current-stage3-amd64-llvm-openrc/latest-stage3-amd64-llvm-openrc.txt"
image="gentoo"
tag=""

function pull {
  local basename=`curl -s "$source" | grep -o 'stage3.* ' | xargs`
  tag="${basename%%.*}"

  local tags=(`docker images --format '{{.Tag}}' "$image"`)
  [[ " ${tags[@]} " =~ " $tag " ]] && return

  local stage3=`dirname "$source"`/"$basename"
  docker import "$stage3" "$image:$tag"
}

function run {
  function v (echo "-v $1:$1")

  local config=`dirname $(realpath $0)`

  exec docker run -it --privileged \
    -v "$config":/etc/portage \
    `v /tmp` `v /var/cache` `v /var/db/repos` `v /var/tmp` \
    "$@" "$image:$tag" bash
}

pull
run "$@"
