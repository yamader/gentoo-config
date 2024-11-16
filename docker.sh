#!/usr/bin/env bash

set -e

source="https://ftp.jaist.ac.jp/pub/Linux/Gentoo/releases/amd64/autobuilds/current-stage3-amd64-llvm-openrc/latest-stage3-amd64-llvm-openrc.txt"
image="gentoo"
tag=""

function die {
  echo "$@" >&2
  exit 1
}

function argparse {
  # https://chitoku.jp/programming/bash-getopts-long-options
  while getopts s:i:c-: opt; do
    local opt arg

    # handle long options
    [[ "$opt" = - ]] && opt="-$OPTARG"

    # handle argument
    arg="${!OPTIND}"

    case "-$opt" in
      -s|--source)
        source="$arg"
        shift
        ;;
      -i|--image)
        image="$arg"
        shift
        ;;
      -c|--clean)
        set -x
        docker rmi `docker images -q "$image"`
        exit $?
        ;;
      --)
        break
        ;;
      --*)
        die "$0: illegal option -- ${opt##-}"
        ;;
    esac
  done
  shift $((OPTIND - 1))
}

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

  exec docker run --rm -it --privileged \
    -v "$config":/etc/portage:ro \
    `v /tmp` `v /var/cache` `v /var/db/repos` `v /var/tmp` \
    "$@" "$image:$tag" bash
}

#--------------------------------------------------------------#

argparse
pull
run "$@"
