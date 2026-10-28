HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

if (( ${path[(Ie)$HOME/.local/bin]} == 0 )); then
  path=("$HOME/.local/bin" $path)
fi

autoload -Uz compinit
compinit

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v brew >/dev/null 2>&1; then
  brew_prefix=$(brew --prefix 2>/dev/null)
  autosuggestions="$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  syntax_highlighting="$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r "$autosuggestions" ]] && source "$autosuggestions"
fi

alias cz='code "${ZDOTDIR:-$HOME}/.zshrc"'
alias sz='source "${ZDOTDIR:-$HOME}/.zshrc"'
alias c='clear'
alias c.='code .'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lah'

alias ga='git add'
alias gb='git branch -vv'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all'
alias gl='git log --oneline --graph --decorate -20'
alias gpl='git pull --ff-only'
alias gps='git push'
alias gs='git status --short --branch'
alias gsl='git stash list'
alias gst='git stash push'
alias gsw='git switch'

alias py='python'
alias serve='python -m http.server --bind 127.0.0.1'
alias mls='mise ls'
alias jf='python -m json.tool'
alias pth='printf "%s\n" "${path[@]}"'

gn() {
  (( $# == 1 )) || { print -u2 'Usage: gn <branch>'; return 2; }
  git switch -c "$1"
}

gpk() {
  local branches branch
  branches=$(git for-each-ref --format='%(refname:short)' refs/heads/) || return
  [[ -n "$branches" ]] || return 1
  branch=$(printf '%s\n' "$branches" | fzf --prompt='Git branch > ') || return
  git switch -- "$branch"
}

grt() {
  local root
  root=$(git rev-parse --show-toplevel) || return
  builtin cd -- "$root"
}

mkcd() {
  (( $# == 1 )) || { print -u2 'Usage: mkcd <directory>'; return 2; }
  mkdir -p -- "$1" && builtin cd -- "$1"
}

venv() {
  (( $# == 0 )) || { print -u2 'Usage: venv'; return 2; }
  [[ -d .venv ]] || python -m venv .venv || return
  [[ -f .venv/bin/activate ]] || return 1
  source .venv/bin/activate
}

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

if [[ -r "$syntax_highlighting" ]]; then
  source "$syntax_highlighting"
fi
