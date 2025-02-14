#!/usr/bin/env sh

check_command() {
    return $(command -v $1 $ >/dev/null)
}

request_response() {
    printf "$1 "
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
