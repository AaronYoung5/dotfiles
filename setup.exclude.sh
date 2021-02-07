# --------------------------------
# Clones and installs the dotfiles
# --------------------------------
echo TEST
exit
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

# Setup the pseudo user directory
[ ! -d $USER_HOME ] && echo "$USER_HOME not a directory. Creating it." && mkdir -p $USER_HOME
USER_HOME=$(readlink -f $USER_HOME)
cd $USER_HOME

# Clone the repo
git clone git@github.com:AaronYoung5/dotfiles .dotfiles
cd .dotfiles

# Run the bootstrap script
USER_HOME=$USER_HOME ./bootstrap.user.exclude.sh

# Add alias to the zsh_aliases.local file
sed -i "/pseudousers/a alias $ALIAS=\"tu $USER_HOME $ALIAS\"" $HOME/.zsh_aliases.local

