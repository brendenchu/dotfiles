#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$SCRIPT_DIR")
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

case "$(uname -s)" in
  Darwin)
    if [ "$DRY_RUN" -eq 1 ]; then
      printf 'Would run: brew bundle --file=%s/Brewfile\n' "$ROOT"
      cat "$ROOT/Brewfile"
      exit 0
    fi
    if ! command -v brew >/dev/null 2>&1; then
      printf 'Homebrew is required. Install it first, then rerun this script.\n' >&2
      exit 1
    fi
    brew bundle --file="$ROOT/Brewfile"
    ;;
  Linux)
    if ! command -v apt-get >/dev/null 2>&1; then
      printf 'This Linux package installer supports Debian/Ubuntu (apt-get) only.\n' >&2
      exit 1
    fi
    if [ ! -r /etc/os-release ] || ! grep -Eq '^(ID|ID_LIKE)=.*(debian|ubuntu)' /etc/os-release; then
      printf 'This Linux package installer supports Debian/Ubuntu only.\n' >&2
      exit 1
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '%s\n' 'Would run: sudo apt-get update'
      printf '%s\n' 'Would run: sudo apt-get install -y'
      cat "$ROOT/packages/apt.txt"
      exit 0
    fi
    sudo apt-get update
    xargs -r sudo apt-get install -y < "$ROOT/packages/apt.txt"
    ;;
  *)
    printf 'Unsupported platform. Use install-packages.ps1 on Windows.\n' >&2
    exit 1
    ;;
esac
