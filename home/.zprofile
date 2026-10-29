typeset -U path
path=("$HOME/.local/bin" $path)

export EDITOR=vim
export VISUAL=vim

if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi
fi

# Shims expose mise tools to non-interactive login shells (IDE tasks, hooks).
# Interactive shells replace them with `mise activate` in .zshrc.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi

if [[ -f "$HOME/.zprofile.local" ]]; then
  source "$HOME/.zprofile.local"
fi
