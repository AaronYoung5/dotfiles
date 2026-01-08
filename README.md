# Dotfiles

Personal dotfiles managed with [yadm](https://yadm.io/), featuring profile-based pseudo-users and host-specific configurations.

## Quick Start

```bash
curl -L bootstrap.yadm.io | bash -s -- https://github.com/AaronYoung5/dotfiles.git
```

## Features

- **Pseudo-user profiles**: Isolated environments for different contexts (personal, work, school)
- **Host-specific configs**: Automatic variants using yadm's `##` syntax
- **tmux integration**: Auto-attach to profile-specific sessions
- **Plugin managers**: vim-plug and TPM pre-configured

## Usage

```bash
# Switch profiles
pseudo personal
pseudo work

# Create aliases
pseudo-alias p personal

# List profiles
pseudo-list
```

## Structure

```
.config/yadm/bootstrap          # Main bootstrap + bootstrap.d/ scripts
.dotfiles/
  zsh/
    aliases.zsh##default
    functions.zsh##default
    exports.zsh##default
    profiles/
      personal.zsh##default
      personal.zsh##h.cc-mac  # Host-specific variant
  packages/
    brew.list                   # Homebrew packages
    apt.list                    # apt packages
.zshrc##default
.vimrc##default
.tmux.conf##default
```

## Adding Profiles

Create `~/.dotfiles/zsh/profiles/<name>.zsh##default`:

```bash
export PSEUDO_USER="work"
export TMUX_SESSION_NAME="work"
export USER_HOME="$HOME/Pseudos/work"
export GIT_AUTHOR_EMAIL="you@work.com"
mkdir -p "$USER_HOME"
```

Optional host variant sourcing default:
```bash
# work.zsh##h.cc-mac
source "${0:A:h}/work.zsh##default"
export WORK_SPECIFIC_VAR="value"
```

Run `yadm alt` to link variants.

## Key Bindings

### Vim
- Leader: `Space`
- Exit insert: `jk`
- Save: `<leader>w`
- NERDTree: `<leader>n`

### Tmux  
- Split vertical: `<prefix>v`
- Split horizontal: `<prefix>s`
- Navigate panes: `h/j/k/l`
- Reload config: `<prefix>r`

## Docker Testing

Test dotfiles installation locally on different Linux distributions.

### Ubuntu
```bash
docker run -it --rm -e HOSTNAME=test -v "$(pwd)":/mnt/dotfiles:ro ubuntu:latest bash -c '
  apt-get update && apt-get install -y git && \
  git config --global user.email "test@test.com" && \
  git config --global user.name "Test" && \
  git config --global init.defaultBranch main && \
  cp -r /mnt/dotfiles $HOME/repo && cd $HOME/repo && \
  rm -rf .git && git init && git add -A && git commit -m "test" && \
  curl -L bootstrap.yadm.io | bash -s -- file://$HOME/repo && \
  exec zsh -l
'
```

### Fedora
```bash
docker run -it --rm -e HOSTNAME=test -v "$(pwd)":/mnt/dotfiles:ro fedora:latest bash -c '
  dnf install -y git && \
  git config --global user.email "test@test.com" && \
  git config --global user.name "Test" && \
  git config --global init.defaultBranch main && \
  cp -r /mnt/dotfiles $HOME/repo && cd $HOME/repo && \
  rm -rf .git && git init && git add -A && git commit -m "test" && \
  curl -L bootstrap.yadm.io | bash -s -- file://$HOME/repo && \
  exec zsh -l
'
```

### Arch Linux
```bash
docker run -it --rm --platform linux/amd64 -e HOSTNAME=test -v "$(pwd)":/mnt/dotfiles:ro archlinux:latest bash -c '
  pacman -Syu --noconfirm git && \
  git config --global user.email "test@test.com" && \
  git config --global user.name "Test" && \
  git config --global init.defaultBranch main && \
  cp -r /mnt/dotfiles $HOME/repo && cd $HOME/repo && \
  rm -rf .git && git init && git add -A && git commit -m "test" && \
  curl -L bootstrap.yadm.io | bash -s -- file://$HOME/repo && \
  exec zsh -l
'
```

Inside container, test: `pseudo-list` and `pseudo personal`

## Managing Dotfiles

```bash
yadm status
yadm add .dotfiles/zsh/profiles/new.zsh##default
yadm commit -m "Add new profile"
yadm push
yadm alt  # Regenerate symlinks
```
