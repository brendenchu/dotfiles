# Dotfiles

Personal macOS setup for Zsh, Git, Ghostty, Starship, mise, Vim, and VS Code.
Other platforms can be added when needed.

## Install

Preview the links, then install:

```sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

The installer backs up conflicting files beside their original paths with a
`.dotfiles-backup-<timestamp>` suffix. It does not install packages or runtimes.
To undo, remove only links created by the installer and restore any backups.
The installer does not delete backups.

If you have machine-specific Zsh settings, review the backup of your existing
`.zshrc` or `.zprofile` and move only the needed settings into
`~/.zshrc.local` or `~/.zprofile.local`. Those files are sourced locally and
are not tracked here.

Keep Git identity in `~/.gitconfig.local`; the tracked Git config includes
that file when present:

```sh
git config --file "$HOME/.gitconfig.local" user.name "Your Name"
git config --file "$HOME/.gitconfig.local" user.email "you@example.com"
```

## Packages and runtimes

Review [Brewfile](./Brewfile), then install its small macOS baseline with:

```sh
brew bundle --file Brewfile
```

After mise is installed and the shell is restarted, install the pinned tools
separately when ready:

```sh
mise install
```

This downloads the versions in `~/.config/mise/config.toml`. The current list
is limited to Python, Node.js, Go, PHP, fzf, GitHub CLI, Starship, and zoxide.
Starship's config lives alongside the other XDG configs at
`~/.config/starship.toml`.

## Included settings

- Zsh history, common navigation/Git shortcuts, Python helpers, and optional
  mise, fzf, zoxide, Starship, and Homebrew plugin integrations
- Git defaults and aliases, automatic upstream setup for new branches,
  remembered conflict resolutions, and a global ignore rule
- GitHub CLI SSH preference and pull-request checkout alias; credentials and
  host state stay local
- Ghostty settings: ZedMono Nerd Font at 16pt, block cursor, Catppuccin Mocha,
  and hide the mouse pointer while typing
- A compact Starship prompt for Git state and the language runtimes above
- Vim defaults and shared VS Code settings

Install ZedMono Nerd Font for the Ghostty font setting, or change it to a font
available on your Mac. Machine-specific settings and credentials do not belong
in this repository.

## Verify

Run `sh -n scripts/install.sh`, `/bin/zsh -n home/.zshrc home/.zprofile`, then
preview the links with `./scripts/install.sh --dry-run`.
