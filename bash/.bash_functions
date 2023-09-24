#!/usr/bin/env bash

# source a python virtual environment
se() {
	# Ternary operator replicator
	env_name=${1:-"env"}
	source "$env_name/bin/activate"
}

# Create a tmux session with a specific USER_HOME
tu() {
	[ -z $1 ] || [ -z $2 ] && echo "USAGE: $0 [ USER_HOME ] [ SESSION_NAME ]" && return
	[ ! -d $1 ] && echo "$1 is not a directory." && return
	USER_HOME=$1

	[ ! -z $2 ] && SESSION_NAME=$2

	USER_HOME=$USER_HOME tmux -S $USER_HOME/.tmux_socket new -A -s $SESSION_NAME
}

# Create a pseudo user
create-psuedo-user() {
	[ -z $1 ] || [ -z $2 ] && echo "USAGE: $0 [ USER_HOME ] [ ALIAS / SESSION_NAME ]" && return
	USER_HOME=$1
	ALIAS=$2

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/AaronYoung5/dotfiles/develop/setup_psuedouser.exclude.sh)" "" $ALIAS $USER_HOME
}

# This should be the last line of the file
# For local changes
# Don't make edits below this
[ -f ".zsh_functions.local" ] && source ".zsh_functions.local"
