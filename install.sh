#!/bin/bash
# Symlinks every tracked config in this repo into place.
# Run this after cloning onto a new/other Omarchy machine.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local repo_path="$1" target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [[ -e "$target_path" && ! -L "$target_path" ]]; then
    mv "$target_path" "$target_path.bak.$(date +%s)"
    echo "Backed up existing $target_path"
  fi

  ln -sf "$REPO_DIR/$repo_path" "$target_path"
  echo "Linked $target_path -> $repo_path"
}

link "hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"

# Add more `link "repo/path" "$HOME/.config/path"` lines here as you track more files.
