#!/usr/bin/env bash

source ./helpers.exclude.sh

# --------------------

required_commands="git curl vim tmux wget ssh $@"
setup_platform_specific $required_commands
configure_auxillaries

true
