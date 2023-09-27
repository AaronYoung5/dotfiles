#!/usr/bin/env sh

. $DOTFILES/helpers.exclude.sh

# --------------------

platform_specific_sed
platform_specific_readlink

# --------------------

[ -z $1 ] || [ -z $2 ] && echo "USAGE: $0 [ USER_HOME ] [ ALIAS ]" && exit
USER_HOME=$1
ALIAS=$2

# --------------------

confirm "USER_HOME is set to '$USER_HOME' and ALIAS is set to '$ALIAS'. Is that okay? [Y/n] " || exit

# --------------------

[ -d $USER_HOME/.dotfiles ] && echo "$USER_HOME already seems to be setup. Exitting..." && exit

mkdir -p $USER_HOME
cd $USER_HOME

# --------------------

# Clone the repo
git clone git@github.com:AaronYoung5/dotfiles .dotfiles
[ ! -d .dotfiles ] && echo "Failed to clone dotfiles. Exitting..." && exit
cd $USER_HOME/.dotfiles

# --------------------

# Run the bootstrap script
USER_HOME=$USER_HOME ./bootstrap.user.exclude.sh

# --------------------

# Add alias to the $SHELL_aliases.local file
$SED -i --follow-symlinks "/pseudousers/a alias $ALIAS=\"tu $USER_HOME $ALIAS\"" $HOME/.$(basename $SHELL)_aliases.local

# Add include to ssh config file
$SED -i --follow-symlinks "/pseudousers/a Include $USER_HOME/.ssh/config" $HOME/.ssh/config

# If anaconda installed, add additional aliases for it
if command -v conda --version $ >/dev/null; then
	conda create --prefix $USER_HOME/.conda/envs/$ALIAS python=3.8
	$SED -i --follow-symlinks "/Additional aliases/a alias $ALIAS=\"conda activate \$USER_HOME/.conda/envs/$ALIAS\"" $USER_HOME/.$(basename $SHELL)_aliases.user
fi
