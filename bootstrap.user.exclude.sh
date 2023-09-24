#!/usr/bin/env sh

source ./helpers.exclude.sh

# --------------------

if ! confirm "USER_HOME is set to $USER_HOME. Is that okay? [yn] "; then
	exit
fi

symlink_configs $USER_HOME/.dotfiles $USER_HOME
configure_ssh $USER_HOME/.ssh
mkdir -p $USER_HOME/.local/bin

true
