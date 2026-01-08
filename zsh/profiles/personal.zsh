#!/usr/bin/env zsh

# Personal profile configuration
export PSEUDO_USER="personal"

# Personal-specific aliases
alias notes='vim ~/notes.md'
alias projects='cd ~/Projects'

# Personal git config
export GIT_AUTHOR_EMAIL="you@personal.com"
export GIT_COMMITTER_EMAIL="you@personal.com"

# Add any personal-specific environment variables or configurations here
echo "Loaded personal profile"
