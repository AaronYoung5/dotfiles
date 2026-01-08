# Dotfiles

A bare git repository for managing dotfiles with profile-based pseudo users.

## Features

- **Profile-based environments**: Switch between different work contexts (personal, work, school) with isolated configurations
- **Computer-specific profiles**: Different configurations per machine (e.g., `cc-mac-personal`, `work-laptop-dev`)
- **direnv integration**: Automatic environment loading when entering directories
- **tmux auto-attach**: Automatically attach to or create tmux sessions per profile
- **Minimal structure**: Single files per profile, no complex folder hierarchies

## Installation

### First Time Setup

```bash
# Clone as bare repository
git clone --bare https://github.com/yourusername/dotfiles.git $HOME/.dotfiles

# Set up dotfiles alias
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Checkout files
dotfiles checkout

# Run installation
cd ~/.dotfiles
./install.sh

# Install direnv (if not already installed)
# macOS:
brew install direnv
# Linux:
sudo apt install direnv  # or equivalent
```

### Required Tools

- `zsh` (shell)
- `direnv` (auto-loading environments)
- `tmux` (optional, for session management)
- `git` (version control)

## Usage

### Creating a Pseudo User

```bash
# Create a new pseudo user from a profile
pseudo-create cc-mac-personal

# This will:
# 1. Create ~/Pseudos/cc-mac-personal/
# 2. Symlink the profile's .envrc
# 3. Optionally create a short alias (e.g., 'personal')
# 4. Enter the directory
```

### Switching Profiles

```bash
# Using the full profile name
pseudo-enter cc-mac-personal

# Or use your short alias (if created)
personal
```

### List Available Profiles

```bash
pseudo-list
```

### Adding a New Profile

1. Create `profiles/<profile-name>.envrc` (e.g., `profiles/work-laptop-dev.envrc`)
2. Configure environment variables and settings
3. Run `pseudo-create <profile-name>`

## Testing

### Local Docker Testing

Test your dotfiles in an isolated container before deploying:

```bash
# Build test image (one-time setup)
docker build -t dotfiles-test -f- . <<'EOF'
FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    git curl zsh tmux direnv \
    && rm -rf /var/lib/apt/lists/*
RUN chsh -s /bin/zsh
WORKDIR /root
EOF

# Test with local changes (read-only mount)
docker run -it --rm \
  -e HOSTNAME=test-machine \
  -v "$(pwd)":/mnt/dotfiles:ro \
  dotfiles-test bash -c '
    git clone /mnt/dotfiles/.git ~/.dotfiles && \
    cd ~/.dotfiles && \
    git --git-dir=~/.dotfiles/.git --work-tree=~ checkout -f && \
    ./install.sh && \
    exec zsh -l
  '

# Test from remote repository
docker run -it --rm \
  -e HOSTNAME=test-machine \
  dotfiles-test bash -c '
    git clone --bare https://github.com/yourusername/dotfiles.git ~/.dotfiles && \
    git --git-dir=~/.dotfiles/.git --work-tree=~ checkout -f && \
    cd ~/.dotfiles && \
    ./install.sh && \
    exec zsh -l
  '
```

Inside the container, test the workflow:

```bash
# List available profiles
pseudo-list

# Create a pseudo user
pseudo-create cc-mac-personal

# Should auto-load environment and attach tmux
# Exit tmux with: Ctrl-B, then D (detach)
```

## Structure

```
dotfiles/
  install.sh              # Installation script
  profiles/               # Profile configurations
    cc-mac-personal.envrc
    work-laptop-dev.envrc
  zsh/                    # Zsh configuration
    zshrc                 # Base zshrc
    aliases.base.zsh      # Common aliases
    profiles/             # Profile-specific configs
      personal.zsh
      work.zsh
  README.md
```

## How It Works

1. **Base installation**: `install.sh` symlinks core dotfiles (~/.zshrc, etc.)
2. **Profile creation**: `pseudo-create` creates ~/Pseudos/<profile>/ with symlinked .envrc
3. **Auto-loading**: When you `cd` into a pseudo directory, direnv loads the .envrc
4. **Environment setup**: .envrc sources profile configs and optionally attaches tmux
5. **Isolated contexts**: Each pseudo user has its own environment, history, and tmux session

## Managing with Git

Since this is a bare repository, use the `dotfiles` alias:

```bash
# Check status
dotfiles status

# Add files
dotfiles add profiles/new-profile.envrc

# Commit changes
dotfiles commit -m "Add new profile"

# Push to remote
dotfiles push
```

## Customization

Edit profile-specific configs in:
- `profiles/<profile-name>.envrc` - Environment variables and tmux auto-attach
- `zsh/profiles/<type>.zsh` - Shared configuration for profile types (personal, work, etc.)

## Troubleshooting

### direnv not loading

```bash
# Allow direnv for the directory
cd ~/Pseudos/cc-mac-personal
direnv allow
```

### Pseudo user not found

```bash
# Check if profile exists
pseudo-list

# Create it if needed
pseudo-create <profile-name>
```
