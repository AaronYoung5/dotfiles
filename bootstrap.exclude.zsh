#!/usr/bin/env zsh

source ./helpers.exclude.sh

# --------------------

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

# --------------------

sh ./bootstrap.exclude.sh zsh

# --------------------
# zsh specific
symlink_configs zsh.exclude/
install_oh_my_zsh
install_zgen
check_shell zsh
# --------------------

true
