HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

autoload -Uz compinit
compinit

alias ll='ls -lah'
alias la='ls -A'

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
