#!/bin/zsh

link() {
  for file in $(ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md'); do
    # Silently ignore errors here because the files may already exist
    ln -svf "$PWD/$file" "$HOME" || true
  done
}

configure_vim() {
  if ! command -v vim &>/dev/null; then
    echo "vim is not installed. Install before proceeding."
    exit
  fi

  if [ ! -f $HOME/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
  fi
}

install_oh_my_zsh() {
  if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
  fi
}

install_zgen() {
  if [ ! -d $HOME/.zgen ]; then
    git clone https://github.com/tarjoilija/zgen.git "$HOME/.zgen"
  fi
}

configure_vim
install_oh_my_zsh
install_zgen
link

# Ignore local files
git update-index --skip-worktree .zsh*.local

echo "Restart your terminal to have changes take effect."

true
