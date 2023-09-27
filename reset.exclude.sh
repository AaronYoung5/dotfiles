#!/usr/bin/env sh

. ./helpers.exclude.sh

# --------------------

check_args() {
	[ -z "$2" ] || [ -z "$3" ] && echo "USAGE: $1 [ HOME ] [ DOTFILES ]" && exit 0
}

confirm_args() {
	platform_specific_readlink
	confirm "Resetting directory $($READLINK -f "$1") with dotfiles $($READLINK -f "$2"). Is that okay? [Y/n]" || exit 0
}

rm_dotfiles() {
	platform_specific_readlink

	home=$($READLINK -f "$1")
	for file in $home/.*; do
		echo "Checking $file"
		if [ -L "$file" ]; then
			if [[ "$($READLINK "$file")" == *"$2"* ]]; then
				echo "Removing symlink '$file'"
				rm "$file"
			fi
		fi
	done
}
