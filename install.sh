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

# Reload Hyprland so linked changes take effect immediately, instead of only
# on the next login. Skipped quietly if Hyprland isn't running (e.g. this
# script ran before the first login on a fresh setup).
if command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1; then
  echo "Reloaded Hyprland config"
  errors="$(hyprctl configerrors 2>/dev/null || true)"
  if [[ -n "$errors" ]]; then
    echo "Hyprland reported config errors:"
    echo "$errors"
  fi
else
  echo "Hyprland not running - skipped reload (changes apply on next login)"
fi
