if (( ${path[(Ie)$HOME/.local/bin]} == 0 )); then
  path=("$HOME/.local/bin" $path)
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi
fi

if [[ -f "$HOME/.zprofile.local" ]]; then
  source "$HOME/.zprofile.local"
fi
