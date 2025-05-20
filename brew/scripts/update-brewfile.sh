#!/usr/bin/env bash
set -euo pipefail

BREW=/opt/homebrew/bin/brew
DOTFILES="$HOME/.dotfiles"
BREWFILE_DIR="$DOTFILES/brew"
BREWFILE="$BREWFILE_DIR/Brewfile"

cd "$DOTFILES"
git pull --ff-only

# Keep Homebrew itself fresh
$BREW update --quiet
$BREW upgrade --quiet
$BREW cleanup --prune=all --quiet

# Dump to the right Brewfile path
$BREW bundle dump --force --file="$BREWFILE"

# If it changed, commit & push
if [[ -n "$(git status --porcelain "$BREWFILE")" ]]; then
  git add "$BREWFILE"
  git commit -m "chore(brew): auto-dump Brewfile on $(date +'%Y-%m-%d')"
  git push
fi
