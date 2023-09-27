#!/usr/bin/env sh

. ./helpers.exclude.sh

# --------------------

symlink_configs $USER_HOME/.dotfiles/$(basename $SHELL) $USER_HOME
configure_ssh $USER_HOME/.ssh
mkdir -p $USER_HOME/.local/bin

true
