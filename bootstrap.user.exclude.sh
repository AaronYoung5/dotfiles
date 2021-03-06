#!/usr/bin/env bash

link() {
  [ -z $USER_HOME ] && echo "USER_HOME is unset. Set it before continuing." && exit

  read -p "USER_HOME is set to $USER_HOME. Is that okay? [yn] " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
	  for file in $(ls -A | grep '\.user' | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md|\.*.swp|\.last_update'); do
	    # Silently ignore errors here because the files may already exist
	    if [[ -f "$USER_HOME/$file" ]]; then
		    echo "$USER_HOME/$file already exists. Please delete before continuing."
		    continue
	    fi
	    ln -svf "$USER_HOME/.dotfiles/$file" "$USER_HOME" || true
	  done
  fi
}

link

git update-index --skip-worktree .zsh*.user

# Setup ssh
mkdir $USER_HOME/.ssh
touch $USER_HOME/.ssh/config

# Setup local
mkdir -p $USER_HOME/.local/bin

true
