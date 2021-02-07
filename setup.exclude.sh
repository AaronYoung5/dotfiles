#!/bin/zsh

# --------------------------------
# Clones and installs the dotfiles
# --------------------------------

help() {
	echo
	echo "USAGE: $0 [-u/--user_home user_home] [-a/--alias alias]"
}

USER_HOME=$PWD
ALIAS=$(basename $PWD)

# Parse command line inputs
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-u|--user_home)
			[ -z $2 ] && echo "Please specify a user_home" && help && exit
			[ ! -d $2 ] && echo "$2 not a directory. Creating it." && mkdir -p $2
			USER_HOME=$2
			shift
			shift
			;;
		-a|--alias)
			[ -z $2 ] && echo "Please specify an alias" && help && exit
			ALIAS=$2
			shift
			shift
			;;
		*)
			echo "Unknown option: $1"
			echo "Ignoring..."
	esac
done

# Clone the repo
# git clone git@github.com:AaronYoung5/dotfiles.git $PREFIX/.dotfiles
# cd $PREFIX/.dotfiles
