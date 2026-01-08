#!/usr/bin/env zsh

# Base aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Pseudo user management functions
function pseudo-create() {
  local profile_name="$1"
  
  if [[ -z "$profile_name" ]]; then
    echo "Usage: pseudo-create <profile-name>"
    echo "Example: pseudo-create cc-mac-personal"
    return 1
  fi
  
  local profile_envrc="$DOTFILES_DIR/profiles/${profile_name}.envrc"
  
  # Check if profile exists
  if [[ ! -f "$profile_envrc" ]]; then
    echo "Error: Profile '$profile_name' not found at $profile_envrc"
    echo "Available profiles:"
    ls -1 "$DOTFILES_DIR/profiles" 2>/dev/null | sed 's/\.envrc$//' | sed 's/^/  - /'
    return 1
  fi
  
  local pseudo_dir="$PSEUDOS_DIR/$profile_name"
  
  # Check if already exists
  if [[ -d "$pseudo_dir" ]]; then
    echo "Pseudo user '$profile_name' already exists at $pseudo_dir"
    read "response?Enter anyway? (y/n) "
    if [[ "$response" != "y" ]]; then
      return 0
    fi
  else
    echo "Creating pseudo user: $profile_name"
    mkdir -p "$pseudo_dir"
    ln -sf "$profile_envrc" "$pseudo_dir/.envrc"
    
    # Ask for short alias
    read "short_alias?Create short alias? (leave empty to skip, or enter alias name): "
    if [[ -n "$short_alias" ]]; then
      echo "alias $short_alias='pseudo-enter $profile_name'" >> ~/.config/zsh/aliases.local.zsh
      echo "✓ Created alias: $short_alias"
      echo "  (Reload shell or run: source ~/.zshrc)"
    fi
    
    echo "✓ Pseudo user created at: $pseudo_dir"
  fi
  
  # Enter the pseudo user
  cd "$pseudo_dir"
}

function pseudo-enter() {
  local profile_name="$1"
  local pseudo_dir="$PSEUDOS_DIR/$profile_name"
  
  if [[ ! -d "$pseudo_dir" ]]; then
    echo "Pseudo user '$profile_name' doesn't exist."
    read "response?Create it now? (y/n) "
    if [[ "$response" == "y" ]]; then
      pseudo-create "$profile_name"
    fi
    return
  fi
  
  cd "$pseudo_dir"
}

function pseudo-list() {
  echo "Available profiles:"
  ls -1 "$DOTFILES_DIR/profiles" 2>/dev/null | sed 's/\.envrc$//' | sed 's/^/  - /'
  
  echo "\nCreated pseudo users:"
  if [[ -d "$PSEUDOS_DIR" ]]; then
    ls -1 "$PSEUDOS_DIR" 2>/dev/null | sed 's/^/  - /' || echo "  (none)"
  else
    echo "  (none)"
  fi
}

# Load user's local aliases (for short aliases created during pseudo-create)
[[ -f ~/.config/zsh/aliases.local.zsh ]] && source ~/.config/zsh/aliases.local.zsh
