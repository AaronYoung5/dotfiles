#!/usr/bin/env zsh

DIR=$(cd "$(dirname -- "$0")" && pwd)
FILE=$(basename "$0")
. ${DIR}/${FILE}##default

eval "$(/opt/homebrew/bin/brew shellenv)"