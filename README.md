# Dotfiles

Yadm-managed dotfiles with pseudo-user profiles for isolated development environments.

## Quick Start

```bash
# Initial setup
curl -L bootstrap.yadm.io | bash -s -- https://github.com/AaronYoung5/dotfiles.git

# Update
yadm pull && yadm alt && yadm bootstrap
```

## Features

- **Pseudo-users**: Isolated tmux sessions with custom configs per context
- **Host variants**: Auto-selected configs via yadm `##h.hostname` syntax  
- **Auto-bootstrap**: Package installation, vim-plug, micromamba

## Usage

```bash
personal              # Switch to personal profile (auto-tmux)
pseudo-list           # Show available profiles
pseudo-alias p work   # Create shortcut
```

## Structure

```
.dotfiles/zsh/
  profiles/
    personal.zsh##default      # Base profile
    personal.zsh##h.cc-mac     # Host override
.zshrc##default
.vimrc##default
.tmux.conf##default
```

## Adding Profiles

`~/.dotfiles/zsh/profiles/work.zsh##default`:
```zsh
export PSEUDO_USER=\"work\"
export TMUX_SESSION_NAME=\"work\"
export USER_HOME=\"$PSEUDOS_DIR/work\"
mkdir -p \"$USER_HOME\"
```

Run `yadm alt` to activate.

## Keybindings

**Vim**: `Space` = leader, `jk` = exit insert, `<leader>n` = NERDTree  
**Tmux**: `<prefix>v/s` = split, `hjkl` = navigate

## Testing

```bash
# Ubuntu
docker run -it --rm ubuntu:latest bash -c 'apt update && apt install -y git curl && curl -L bootstrap.yadm.io | bash -s -- https://github.com/AaronYoung5/dotfiles.git && exec zsh'

# Arch (ARM Mac)
docker run -it --rm --platform linux/amd64 archlinux:latest bash -c 'pacman -Syu --noconfirm git curl && curl -L bootstrap.yadm.io | bash -s -- https://github.com/AaronYoung5/dotfiles.git && exec zsh'
```
