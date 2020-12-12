# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true

# load plugin
plugins=(git)

source $ZSH/oh-my-zsh.sh

# clone zgen if necessary
if [ ! -d $HOME/.zgen ]; then
    git clone https://github.com/tarjoilija/zgen.git "$HOME/.zgen"
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then
    zgen prezto prompt theme 'suse'
    zgen prezto
    zgen prezto archive
    zgen prezto autosuggestions
    zgen prezto completion
    zgen prezto git
    zgen load zsh-users/zsh-syntax-highlighting
    zgen save
fi

# zsh theme
autoload -U promptinit
promptinit
prompt pure

# By default, if you type in a directory and hit enter
# zsh will cd into that dir. I don't like that
unsetopt AUTO_CD

# History to save
SAVEHIST=1000000
HISTFILE=$HOME/.zsh_history
export HISTCONTROL=ignoredups # Ignore repeat commands when using the up arrow

# Prepend the function path with the zsh completions functions
fpath=(/usr/local/share/zsh-completions $fpath)

# source other files
[ -f ~/.zsh_aliases ] && source "$HOME/.zsh_aliases"
[ -f ~/.zsh_exports ] && source "$HOME/.zsh_exports"
[ -f ~/.zsh_functions ] && source "$HOME/.zsh_functions"
[ -f ~/.zsh_aliases ] && source "$HOME/.zsh_aliases"

# This should be the last line of the file
# For local changes
# Don't make edits below this
[ -f ".zshrc.local" ] && source ".zshrc.local"