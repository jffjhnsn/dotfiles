#!/usr/bin/env bash
set -euo pipefail

DOTFILES=~/.dotfiles
cd "$DOTFILES"

# pull any manual changes first
git pull --ff-only

# regenerate Brewfile from whatever’s currently installed
brew bundle dump --force --file="$DOTFILES/Brewfile"

# if it changed, commit & push
if [[ -n "$(git status --porcelain Brewfile)" ]]; then
  git add Brewfile
  git commit -m "chore(brew): auto-dump Brewfile on $(date +'%Y-%m-%d')"
  git push
fi
