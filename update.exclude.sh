#!/usr/bin/env bash

#
# check for updates (to anything) regularly
#
# Can be used for things like checking if dotfiles repos have new changes, if
# package managers have updates, renewing credentials, etc.
#
# Authors
#   Jake Zimmerman <jake@zimmerman.io>
#	Aaron Young <aarony3131@gmail.com> (editted original)
#
# Usage
#   - Requires my colors.sh to have been sourced already for colorized output
#   - source this file to check if the "system is out of date" (i.e., hasn't
#     been updated in UPDATE_THRESHOLD seconds)
#   - call `update` to run general update checks and checks defined by the
#     system
#     - define a function `update-host` and bind it to the environment before
#       calling update!
#
# Notes
#   This file will only check for updates every time it's sourced. It's meant
#   to be sourced in a bashrc or zshrc so that every time you open a new tab or
#   pane it reminds you if you haven't updated in a while. It neither checks
#   continuously for updates, nor fetches the updates themselves.
#
# TODOs
#   Maybe some day I'll turn this into a fully-configurable file, but for now
#   most things are hard coded.

# Number of seconds to wait before printing a reminder
UPDATE_THRESHOLD="86400"

# update - fetch updates
# usage:
#   update
#
# You will likely also want to define a function `update-host` for each host
# that you will run `update` from. Ensure that this function is sourced before
# calling `update`.
update() {
	# Record that we've update
	touch $DOTFILES/.last_update

	# --- Host-independent updates ---

	# Check dotfiles repo
	# echo "==> Checking repo for any changes"
	cd $DOTFILES
	git fetch origin
	reslog=$(git log HEAD..origin/develop --oneline)
	if [[ "$reslog" != "" ]]; then
		echo "==> Updating dotfiles..."
		git pull
	else
		true
		# echo "==> No updates necessary"
	fi

	cd - &>/dev/null
}

check_for_updates() {
	[ ! -e $DOTFILES/.last_update ] && touch $DOTFILES/.last_update
	# Initialize for when we have no GNU date available
	last_check=0
	time_now=0

	# Darwin uses BSD, check for gdate, else use date
	if [[ $(uname) = "Darwin" && -n $(which gdate) ]]; then
		last_login=$(gdate -r ~/.last_update +%s)
		time_now=$(gdate +%s)
	else
		# Ensure this is GNU grep
		if [ -n "$(date --version 2>/dev/null | grep GNU)" ]; then
			last_login=$(date -r $DOTFILES/.last_update +%s)
			time_now=$(date +%s)
		fi
	fi

	time_since_check=$((time_now - last_login))

	if [ "$time_since_check" -ge "$UPDATE_THRESHOLD" ]; then
		# echo "==> Your system is out of date!"

		update
	fi
}

check_for_updates
