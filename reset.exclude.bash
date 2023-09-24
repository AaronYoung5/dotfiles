#!/usr/bin/env zsh

# Reset the zsh environment
# Will delete all symlinked files and delete zgen, oh-my-zsh and last_update

source ./helpers.exclude.sh
source ./reset.exclude.sh

# --------------------

check_args "$@"
confirm_args "$@"
rm_dotfiles "$@"
