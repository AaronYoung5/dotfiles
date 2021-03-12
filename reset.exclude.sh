#!/usr/bin/env bash

# Reset the zsh environment
# Will delete all symlinked files and delete zgen, oh-my-zsh and last_update

mkdir backups
for filename in $(find $HOME -maxdepth 1 -type l); do
	if  [ -f "$filename" ]; then
		cp $filename backups
		unlink $filename
	fi
done

if [ -d "$HOME/.oh-my-zsh/" ]; then
	rm -rf $HOME/.oh-my-zsh/
fi

if [ -d "$HOME/.zgen/" ]; then
	rm -rf $HOME/.zgen/
fi

if [ -d "$HOME/.vim/" ]; then
	rm -rf $HOME/.vim/
fi
