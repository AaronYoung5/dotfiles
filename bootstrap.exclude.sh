#!/usr/bin/env bash

DOTFILES=$(realpath $(dirname $BASH_SOURCE))

check_install() {
  if ! command -v $1 $>/dev/null; then
	echo "$1 is not installed. Install before proceeding."
	exit
  fi
}

link() {
  for file in $(ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md|\.*.swp|\.last_update'); do
    # Silently ignore errors here because the files may already exist
    ln -svf "$PWD/$file" "$HOME" || true
  done
}

configure_vim() {
  if [ ! -f $HOME/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim +PlugInstall +qall
}

install_oh_my_zsh() {
  unset ZSH
  if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
  fi
}

install_zgen() {
  if [ ! -d $HOME/.zgen ]; then
    git clone https://github.com/tarjoilija/zgen.git "$HOME/.zgen"
  fi
}

configure_git() {
  name=$(git config user.name)
  if [ -z "$name" ]; then
	  read -p "Enter git username: " USER_NAME
	  git config --global user.name $USER_NAME
  fi

  email=$(git config user.email)
  if [ -z "$email" ]; then
	  read -p "Enter git email: " USER_EMAIL
	  git config --global user.email $USER_EMAIL
  fi

  # Ignore local files
  git update-index --skip-worktree .zsh*.local
}

check_for_zsh() {
  if [[ "$SHELL" != *"zsh"* ]]; then
	  echo "Please set your default shell to zsh to have the changes take effect."
	  echo "Your current shell is $SHELL"
	  exit
  else
	  echo "Restart your terminal to have changes take effect."
  fi
}

# Check for packages
check_install git
check_install curl
check_install vim
check_install tmux

install_oh_my_zsh
install_zgen
link

configure_vim
configure_git

check_for_zsh

true
