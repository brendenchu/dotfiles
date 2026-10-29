# Dotfiles

Personal macOS setup for Zsh, Git, Ghostty, Starship, mise, Vim, and VS Code.
The installer currently supports macOS only.

[Install](#install) · [Packages and runtimes](#packages-and-runtimes) ·
[Configuration files](#configuration-files) · [Typography](#typography) ·
[Verify](#verify)

## Install

Clone this repository and run these commands from its root. The installer links
files into your home directory, so keep the checkout at a stable location.

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

### Git identity

No identity is tracked here. Keep a general identity in `~/.gitconfig.local`;
the tracked Git config includes that file when present:

```sh
git config --file "$HOME/.gitconfig.local" user.name "Your Name"
git config --file "$HOME/.gitconfig.local" user.email "you@example.com"
```

To use a different email for one GitHub owner, add a conditional include to the
same local file, after the general identity so it takes precedence (Git 2.36+):

```ini
[includeIf "hasconfig:remote.*.url:git@github.com:example-org/**"]
    path = ~/.config/git/example-org.gitconfig
```

A per-repository `git config user.email` overrides both.

## Packages and runtimes

Review [Brewfile](./Brewfile), then install it with:

```sh
brew bundle --file Brewfile
```

The Brewfile installs the base CLI tools, the build dependencies mise needs to
compile PHP, Ghostty, VS Code, the ZedMono Nerd Font, and the VS Code extensions
these settings refer to. If Ghostty or VS Code are already installed outside
Homebrew, adopt them first so the casks do not fail:

```sh
brew install --cask --adopt ghostty visual-studio-code
```

After mise is installed and the shell is restarted, install the configured tools
separately when ready:

```sh
mise install
```

Tool versions and moving version selectors are defined in
[the mise config](home/.config/mise/config.toml). Review that file before running
`mise install`; some selectors can resolve to newer releases over time. PHP and
Erlang are compiled from source, so the first install takes a while; PHP
includes Composer.

Interactive shells use `mise activate`. Login shells also add mise shims to
`PATH`, so tools are available to non-interactive commands such as editor tasks
and Git hooks.

## Included settings

- Zsh history, common navigation/Git shortcuts, Python helpers, and optional
  mise, fzf, Atuin, zoxide, Starship, and Homebrew plugin integrations
- Commands starting with a space are not saved to history
- Atuin replaces Ctrl-R history search; the up arrow keeps normal Zsh history
- Docker CLI completions when `~/.docker/completions` exists; generated completion
  files stay local
- Adds `~/.local/bin` to `PATH` for user-installed CLI tools and sets `EDITOR`
  and `VISUAL` to Vim
- Git defaults and aliases, automatic upstream setup for new branches,
  remembered conflict resolutions, `zdiff3` conflict markers, histogram diffs,
  auto-stash on rebase, branches sorted by recent commits, and global ignore rules
- GitHub CLI SSH preference and pull-request checkout alias; credentials and
  host state stay local
- Ghostty settings: ZedMono Nerd Font at 16pt, block cursor, Catppuccin Mocha,
  and hide the mouse pointer while typing
- A compact Starship prompt for Git state and the language runtimes configured in mise
- Vim defaults with focused cursor/scroll behaviour, smart-case search and
  persistent undo in `~/.vim/undo`, and VS Code settings with
  automatic Islands light/dark themes, Material file/product icons, and a
  centred Zen Mode layout

Zen Mode keeps line numbers and a single tab visible while hiding the status
bar; use the built-in Zen Mode command when you want a focused layout. Vim
highlights the current line and requests a five-line margin when scrolling.

Machine-specific settings and credentials do not belong in this repository.

## Configuration files

| Configuration | Tracked file |
| --- | --- |
| Repository formatting | [`.editorconfig`](.editorconfig) |
| Zsh interactive shell and login setup | [`.zshrc`](home/.zshrc), [`.zprofile`](home/.zprofile) |
| Git defaults and global ignore rules | [`.gitconfig`](home/.gitconfig), [ignore](home/.config/git/ignore) |
| GitHub CLI | [`config.yml`](home/.config/gh/config.yml) |
| Tool versions | [`mise/config.toml`](home/.config/mise/config.toml) |
| Shell prompt | [`starship.toml`](home/.config/starship.toml) |
| Ghostty | [`ghostty/config`](home/.config/ghostty/config) |
| Vim | [`.vimrc`](home/.vimrc) |
| VS Code | [`settings.json`](home/vscode/settings.json) |

The [installer](scripts/install.sh) defines the destination paths. VS Code settings
are linked to the standard macOS Code user profile; other editions and profiles
require separate setup. Settings changed in the VS Code UI, or by Settings Sync,
are written through the link into this repository, so review those diffs before
committing them.

Ghostty also reads `~/Library/Application Support/com.mitchellh.ghostty/config`
after the linked XDG config, so settings in that file override this repository.
The installer warns when that file contains any settings.

Repository formatting uses UTF-8, LF endings, final newlines and two-space
indentation, with tabs for Git config. Markdown retains trailing spaces for hard
line breaks. VS Code recommends the EditorConfig extension when you open this
checkout; other editors need EditorConfig support enabled as well. These rules
apply to repository files and are not installed as global defaults.

## Typography

Edit [VS Code settings](home/vscode/settings.json) to tune editor and integrated
terminal text independently. `fontSize` sets the size in pixels, `fontWeight`
controls weight, `lineHeight` sets the line-height multiplier, and `letterSpacing`
adds horizontal space in pixels. Set
`editor.fontLigatures` to `true` to enable ligatures if your font supports them.
The terminal's bold weight is controlled by `terminal.integrated.fontWeightBold`.

For terminal Vim, change the host terminal's typography: Ghostty uses
`font-family` and `font-size` in `home/.config/ghostty/config` (size is in points),
while VS Code uses the `terminal.integrated.*` settings above. Vim inherits these
settings. VS Code workspace or language settings can override these user defaults.
See [VS Code terminal appearance](https://code.visualstudio.com/docs/terminal/appearance)
for its typography controls.

## Verify

Check shell syntax and preview the links without changing installed files:

```sh
sh -n scripts/install.sh
shellcheck scripts/install.sh
/bin/zsh -n home/.zshrc
/bin/zsh -n home/.zprofile
./scripts/install.sh --dry-run
git diff --check
```

The same checks run in GitHub Actions on every push to `main` and on pull requests.
