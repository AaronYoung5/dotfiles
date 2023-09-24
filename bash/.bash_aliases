#!/usr/bin/env bash

# Alias Shortcuts

# bashrc files
alias brc="vi $HOME/.bashrc"
alias brcl="vi $HOME/.bashrc.local"
alias sb="source $HOME/.bashrc"

# bash_aliases files
alias ba="vi $HOME/.bash_aliases"
alias bal="vi $HOME/.bash_aliases.local"

# bash_exports files
alias be="vi $HOME/.bash_exports"
alias bel="vi $HOME/.bash_exports.local"

# bash_functions files
alias bf="vi $HOME/.bash_functions"
alias bfl="vi $HOME/.bash_functions.local"

# edit .ssh/config file
alias sc="vi $HOME/.ssh/config"

# vimrc
alias vm="vi $HOME/.vimrc"

# Tmux
alias tm="vi $HOME/.tmux.conf"
alias tx="tmux new -A -s"

# User stuff
alias cdu="cd $USER_HOME"

# This should be the last line of the file
# For local changes
# Don't make edits below this
[ -f ".bash_aliases.local" ] && source ".bash_aliases.local"
