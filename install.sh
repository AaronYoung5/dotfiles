#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
PSEUDOS_DIR="${PSEUDOS_DIR:-$HOME/Pseudos}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Dotfiles Installation ===${NC}\n"

# Install base dotfiles
echo -e "${GREEN}Installing base dotfiles...${NC}"
mkdir -p ~/.config/zsh
ln -sf "$DOTFILES_DIR/zsh/zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/zsh/aliases.base.zsh" ~/.config/zsh/aliases.base.zsh
mkdir -p ~/.config/zsh/profiles
ln -sf "$DOTFILES_DIR/zsh/profiles/personal.zsh" ~/.config/zsh/profiles/personal.zsh

# Create pseudos directory
mkdir -p "$PSEUDOS_DIR"

echo -e "\n${GREEN}✓ Base installation complete${NC}"
echo -e "\nTo create a profile, run: ${YELLOW}pseudo-create <profile-name>${NC}"
echo -e "Example: ${YELLOW}pseudo-create cc-mac-personal${NC}\n"
