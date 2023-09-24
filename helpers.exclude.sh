#!/usr/bin/env sh

check_command() {
    return $(command -v $1 $ >/dev/null)
}

check_for_required_commands() {
    required_list=$@
    not_present_list=""
    for install in $required_list; do
        if ! check_command $install; then
            not_present_list="$install_list $install"
        fi
    done
    return $not_present_list
}

request_response() {
    echo -n "$1 "
    read response
}

confirm() {
    local prompt="${1:-Are you sure you want to continue? [Y/n]}"

    request_response "$prompt"
    case "$response" in
    [yY][eE][sS] | [yY] | "")
        return 0 # User confirmed, continue
        ;;
    *)
        return 1 # User canceled, exit with an error code
        ;;
    esac
}

check_platform() {
    if [[ $(uname) = "Darwin" ]]; then
        echo "MacOS"
    elif [[ $(uname) = "Linux" ]]; then
        echo $(lsb_release -si)
    fi
}

check_shell() {
    shell=$(basename $SHELL)
    desired_shell=$1
    if [[ $shell != $desired_shell ]]; then
        echo "Please set your default shell to $desired_shell to have the changes take effect."
        echo "Your current shell is $shell"
        exit
    else
        echo "Restart your terminal to have changes take effect."
    fi
}

# --------------------

symlink_configs() {
    path=$(readlink -f ${1:-"."})
    home=${2:-"$HOME"}

    for file in $(find $path -type f -not -name "*exclude*" -not -name ".git*" -not -name "*.md" -not -name ".*.swp"); do
        # Silently ignore errors here because the files may already exist
        ln -svf "$file" "$home" || true
    done
}

# --------------------

setup_platform_specific() {
    platform = $(check_platform)
    if [[ $(platform) = "MacOS" ]]; then
        setup_mac_software $@
    elif [[ $(platform) = "Ubuntu" ]]; then
        setup_ubuntu_software $@
    else
        echo "WARNING: Unknown platform: $platform. This might cause problems." >&2
        setup_unknown_software $@
    fi
}

setup_mac_software() {
    echo "Setting up MacOS software..."
    required_packages=$@

    # Setup brew
    if ! check_command brew; then
        if confirm "Homebrew is a tool for install packages on MacOS, but it isn't installed. Would you like to install it? [Y/n]"; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "Homebrew is required to continue. Exiting..."
            exit
        fi
    elif confirm "Homebrew is installed. Would you like to update it? [Y/n]"; then
        echo "Updating Brew..."
        brew update
        brew upgrade
    fi

    # Install the required and mac specific packages (if not present)
    required_packages = $(check_for_required_installs $required_packages gnu-sed coreutils)
    if confirm "Would you like to install the required packages? Packages to be installed: $required_packages. [Y/n]"; then
        brew install $required_packages 1>/dev/null
    fi

    # Conda
    if ! check_command conda && confirm "Anaconda is not installed. Would you like to install it? [Y/n]"; then
        brew install --cask anaconda
        /usr/local/anaconda3/bin/conda config --set changeps1 false
    fi

    echo "Done setting up MacOS software."
}

setup_ubuntu_software() {
    echo "Setting up Ubuntu software..."
    required_packages=$@

    required_packages = $(check_for_required_installs $required_packages)
    if confirm "Would you like to install the required packages? Packages to be installed: $required_packages. This requires administrative privileges. [Y/n]"; then
        sudo apt-get install $required_packages 1>/dev/null
    fi

    echo "Done setting up Ubuntu software."
}

setup_unknown_software() {
    platform = $(check_platform)
    echo "Setting up unknown platform: $platform"
    required_packages = $(check_for_required_installs $required_packages)
    # Only print statement if required packages is not empty
    if [ ! -z "$required_packages" ]; then
        echo "WARNING: These packages are required: $required_packages. Cannot be installed because platform is unknown." >&2
        exit
    fi
    echo "Done setting up unknown platform: $platform"
}

# --------------------

platform_specific_sed() {
    if [[ $(uname) = "Darwin" ]]; then
        return "gsed"
    else
        return "sed"
    fi
}

platform_specific_readlink() {
    READLINK=""
    if [[ $(uname) = "Darwin" ]]; then
        READLINK="greadlink"
    else
        READLINK="readlink"
    fi
}

# --------------------

configure_auxillaries() {
    configure_git
    configure_ssh
    configure_vim
}

configure_ssh() {
    home=${1:-"$HOME"}
    mkdir -p $home/.ssh
    if ! test -f "$home/.ssh/config"; then
        touch $home/.ssh/config

        if [[ home = "$HOME" ]]; then
            echo " # Include files for pseudousers" >>$home/.ssh/config
        fi
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
}

configure_vim() {
    if [ ! -f $HOME/.vim/autoload/plug.vim ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    vim +PlugInstall +qall
}
