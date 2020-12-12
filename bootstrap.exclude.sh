#!/bin/zsh

link() {
  for file in $(ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|\.gitmodules|.*.md'); do
    # Silently ignore errors here because the files may already exist
    ln -svf "$PWD/$file" "$HOME" || true
  done
}

link

true
