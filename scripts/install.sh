#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH='' cd "$(dirname "$0")" && pwd)
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

# Installer state lives outside the checkout. Each run's backups and log share a run ID.
STATE_DIR="$HOME_DIR/.local/state/dotfiles"
run_base=$(date '+%Y%m%d-%H%M%S')
RUN_ID=$run_base
suffix=0
while [ -e "$STATE_DIR/backups/$RUN_ID" ] || [ -e "$STATE_DIR/logs/$RUN_ID.log" ]; do
  suffix=$((suffix + 1))
  RUN_ID="$run_base-$suffix"
done
BACKUP_DIR="$STATE_DIR/backups/$RUN_ID"
LOG_FILE=

say() {
  printf '%s\n' "$1"
  if [ -n "$LOG_FILE" ]; then
    printf '%s\n' "$1" >>"$LOG_FILE"
  fi
}

warn() {
  printf '%s\n' "$1" >&2
  if [ -n "$LOG_FILE" ]; then
    printf '%s\n' "$1" >>"$LOG_FILE"
  fi
}

if [ "$DRY_RUN" -eq 1 ]; then
  for dir in backups logs; do
    [ -d "$STATE_DIR/$dir" ] || say "Would create $STATE_DIR/$dir"
  done
else
  mkdir -p "$STATE_DIR/backups" "$STATE_DIR/logs"
  LOG_FILE="$STATE_DIR/logs/$RUN_ID.log"
  say "Run $RUN_ID from $ROOT"
fi

link_file() {
  source_path=$1
  target_path=$2

  if [ ! -f "$source_path" ]; then
    warn "Missing source file: $source_path"
    return 1
  fi

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    say "Already linked: $target_path"
    return
  fi

  backup_path="$BACKUP_DIR/${target_path#"$HOME_DIR"/}"

  if [ "$DRY_RUN" -eq 1 ]; then
    say "Would link $target_path -> $source_path"
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
      say "Would back up $target_path to $backup_path"
    fi
    return
  fi

  parent_dir=$(dirname "$target_path")
  mkdir -p "$parent_dir"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    mkdir -p "$(dirname "$backup_path")"
    mv "$target_path" "$backup_path"
    say "Backed up $target_path to $backup_path"
  fi

  ln -s "$source_path" "$target_path"
  say "Linked $target_path -> $source_path"
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
  warn "Warning: $ghostty_macos_config contains settings that override $HOME_DIR/.config/ghostty/config"
fi

if [ -n "$LOG_FILE" ]; then
  printf 'Log written to %s\n' "$LOG_FILE"
fi
