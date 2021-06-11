#!/usr/bin/env bash

check_install() {
  if ! command -v $1 $>/dev/null; then
	echo "$1 is not installed. Install before proceeding."
	exit
  fi
}

install_platform_specific() {
	if [[ $(uname) = "Darwin" ]]; then
		# Setup brew
		if [[ $(command -v brew) == "" ]]; then
			echo "Brew not installed. Installing..."
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		else
			echo "Updating Brew..."
			brew update
			brew upgrade
		fi

		# Install mac specific packages
		brew install gnu-sed coreutils 1>/dev/null

		# Conda
		if ! brew info anaconda &>/dev/null; then
			read -p "Anaconda is not installed. Would you like to install it? [yn] " -n 1 -r
			echo

			if [[ $REPLY =~ ^[Yy]$ ]]; then
				brew install --cask anaconda
			fi
		fi
		# gsed -i "s,# Anaconda placeholder,# Anaconda path\nexport PATH=\"/usr/local/anaconda3/bin:\$PATH\",g" $PWD/.zshrc

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

	# Set to default
	git config pull.rebase false

  # Ignore local files
  git update-index --skip-worktree .zsh*.local
}

configure_ssh() {
	mkdir -p $HOME/.ssh
	if ! test -f "$HOME/.ssh/config"; then
		touch $HOME/.ssh/config
		echo "# Include files for pseudousers" >> $HOME/.ssh/config
	fi
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
check_install ssh

# Install platform specific packages
install_platform_specific

install_oh_my_zsh
install_zgen
link

configure_vim
configure_git
configure_ssh

check_for_zsh

true
