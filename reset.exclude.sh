#!/usr/bin/env sh

source ./helpers.exclude.sh

# --------------------

check_args() {
	[ -z $1 ] || [ -z $2 ] && echo "USAGE: $0 [ USER_HOME ] [ DOTFILES ]" && exit 0
}

confirm_args() {
	confirm "Resetting directory $1 with dotfiles $2. Is that okay? [Y/n]" || exit 0
}

rm_dotfiles() {
	for file in $1/.*; do
		if [ -L "$file" ]; then
			if [[ "$(readlink "$file")" == *"$2"* ]]; then
				echo "Removing symlink '$file'"
				rm '$file'
			fi
		fi
	done
}
