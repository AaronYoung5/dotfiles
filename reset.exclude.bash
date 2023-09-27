#!/usr/bin/env bash

# Reset the zsh environment
# Will delete all symlinked files and delete zgen, oh-my-zsh and last_update

source ./helpers.exclude.sh
source ./reset.exclude.sh

# --------------------

check_args $0 "$@"
confirm_args "$@"
rm_dotfiles "$@"
