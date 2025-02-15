#!/usr/bin/env zsh

TEMP_USER_HOME=${USER_HOME:-${XDG_CONFIG_HOME:-${HOME}}}
export YADM_DIR=${TEMP_USER_HOME}/.config/yadm
export YADM_DATA=${TEMP_USER_HOME}/.local/share/yadm

export GLOBAL_DOTFILES=${GLOBAL_DOTFILES:-${TEMP_USER_HOME}/.dotfiles}
export USER_DOTFILES=${LOCAL_DOTFILES:-${TEMP_USER_HOME}/.dotfiles}

export GLOBAL_CONFIG_DIR=${GLOBAL_CONFIG_DIR:-${TEMP_USER_HOME}/.config}
export USER_CONFIG_DIR=${LOCAL_CONFIG_DIR:-${GLOBAL_CONFIG}}

export GLOBAL_ZDOTDIR=${GLOBAL_ZDOTDIR:-${GLOBAL_DOTFILES}/zsh}
export USER_ZDOTDIR=${LOCAL_ZDOTDIR:-${USER_DOTFILES}/zsh}

source ${GLOBAL_ZDOTDIR}/zshrc
