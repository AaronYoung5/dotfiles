#!/usr/bin/env sh

. ./helpers.exclude.sh

# --------------------

echo $SHELL
exit
symlink_configs $USER_HOME/.dotfiles/$SHELL $USER_HOME
configure_ssh $USER_HOME/.ssh
mkdir -p $USER_HOME/.local/bin

true
