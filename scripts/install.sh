#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$SCRIPT_DIR")
HOME_DIR=${HOME:?HOME must be set}
DRY_RUN=0

if [ "$#" -gt 1 ]; then
  printf 'Usage: %s [--dry-run]\n' "$0" >&2
  exit 2
fi
if [ "${1-}" = "--dry-run" ]; then
  DRY_RUN=1
elif [ "$#" -eq 1 ]; then
  printf 'Unknown option: %s\nUsage: %s [--dry-run]\n' "$1" "$0" >&2
  exit 2
fi

if [ "$(uname -s)" != "Darwin" ]; then
  printf 'This installer currently supports macOS only.\n' >&2
  exit 1
fi

link_file() {
  source_path=$1
  target_path=$2

  if [ ! -f "$source_path" ]; then
    printf 'Missing source file: %s\n' "$source_path" >&2
    return 1
  fi

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'Already linked: %s\n' "$target_path"
    return
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'Would link %s -> %s\n' "$target_path" "$source_path"
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
      printf 'Would back up existing path: %s\n' "$target_path"
    fi
    return
  fi

  parent_dir=$(dirname "$target_path")
  mkdir -p "$parent_dir"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    timestamp=$(date '+%Y%m%d%H%M%S')
    backup_path="${target_path}.dotfiles-backup-${timestamp}"
    suffix=0
    while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
      suffix=$((suffix + 1))
      backup_path="${target_path}.dotfiles-backup-${timestamp}-${suffix}"
    done
    mv "$target_path" "$backup_path"
    printf 'Backed up %s to %s\n' "$target_path" "$backup_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'Linked %s -> %s\n' "$target_path" "$source_path"
}

vscode_dir="$HOME_DIR/Library/Application Support/Code/User"

link_file "$ROOT/home/.zshrc" "$HOME_DIR/.zshrc"
link_file "$ROOT/home/.zprofile" "$HOME_DIR/.zprofile"
link_file "$ROOT/home/.gitconfig" "$HOME_DIR/.gitconfig"
link_file "$ROOT/home/.vimrc" "$HOME_DIR/.vimrc"
link_file "$ROOT/home/.config/starship.toml" "$HOME_DIR/.config/starship.toml"
link_file "$ROOT/home/.config/mise/config.toml" "$HOME_DIR/.config/mise/config.toml"
link_file "$ROOT/home/.config/git/ignore" "$HOME_DIR/.config/git/ignore"
link_file "$ROOT/home/.config/gh/config.yml" "$HOME_DIR/.config/gh/config.yml"
link_file "$ROOT/home/.config/ghostty/config" "$HOME_DIR/.config/ghostty/config"
link_file "$ROOT/home/vscode/settings.json" "$vscode_dir/settings.json"

# Ghostty loads this macOS-specific file after the XDG config, so its settings win.
ghostty_macos_config="$HOME_DIR/Library/Application Support/com.mitchellh.ghostty/config"
if [ -f "$ghostty_macos_config" ] && grep -Eqv '^[[:space:]]*(#|$)' "$ghostty_macos_config"; then
  printf 'Warning: %s contains settings that override %s\n' \
    "$ghostty_macos_config" "$HOME_DIR/.config/ghostty/config" >&2
fi
