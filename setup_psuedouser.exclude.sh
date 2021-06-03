# --------------------------------
# Clones and installs the dotfiles
# --------------------------------
help() {
	echo
	echo "USAGE: $0 [-u/--user_home user_home] [-a/--alias alias]"
	echo
	exit
}

USER_HOME=$PWD
ALIAS=$(basename $PWD)

# Parse command line inputs
# Get the positional arguments first
# [ -z $1 ] && echo "Script type required." && help && exit
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-u|--user_home)
			[ -z $2 ] && echo "Please specify a user_home" && help && exit
			USER_HOME=$2
			shift
			shift
			;;
		-a|--alias)
			[ -z $2 ] && echo "Please specify an alias" && help && exit
			ALIAS=$2
			shift
			shift
			;;
		*)
			echo "Unknown option: $1"
			echo "Ignoring..."
			shift
	esac
done

# Grab the correct sed command
if [[ $(uname) = "Darwin" ]]; then
	SED=gsed
else
	SED=sed
fi

if [[ $(uname) = "Darwin" ]]; then
	READLINK=greadlink
else
	READLINK=readlink
fi

# Setup the pseudo user directory
[ ! -d $USER_HOME ] && echo "$USER_HOME not a directory. Creating it." && mkdir -p $USER_HOME
[ -d $USER_HOME/.dotfiles ] && echo "$USER_HOME already seems to be setup. Exitting..." && exit
USER_HOME=$($READLINK -f $USER_HOME)
cd $USER_HOME

# Clone the repo
# git clone git@github.com:AaronYoung5/dotfiles .dotfiles
git clone https://github.com/AaronYoung5/dotfiles .dotfiles
[[ ! -d .dotfiles ]] && echo "Failed to clone dotfiles. Exitting..." && exit
cd .dotfiles

# Run the bootstrap script
USER_HOME=$USER_HOME ./bootstrap.user.exclude.sh

# Add alias to the zsh_aliases.local file
$SED -i --follow-symlinks "/pseudousers/a alias $ALIAS=\"tu $USER_HOME $ALIAS\"" $HOME/.zsh_aliases.local

# Add include to ssh config file
$SED -i --follow-symlinks "/pseudousers/a Include $USER_HOME/.ssh/config" $HOME/.ssh/config

# If anaconda installed, add additional aliases for it
if [[ $(command -v conda) != "" ]]; then
	conda create --prefix $USER_HOME/.conda/envs/$ALIAS python=3.8
	$SED -i --follow-symlinks "/Additional aliases/a alias $ALIAS=\"conda activate .conda/envs/$ALIAS\"" $USER_HOME/.zsh_aliases.user
fi

