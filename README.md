# Dotfiles

Personal macOS setup for Zsh, Git, Ghostty, Starship, mise, Vim, and VS Code.
The installer currently supports macOS only.

[Install](#install) · [Packages and runtimes](#packages-and-runtimes) ·
[Configuration files](#configuration-files) · [Typography](#typography) ·
[Verify](#verify)

## Install

Clone this repository to `~/.dotfiles`. The installer links files from the
checkout into your home directory, so the links break if the checkout moves.

```sh
git clone https://github.com/brendenchu/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Preview the links, then install:

```sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

The installer does not install packages or runtimes.

### Backups and logs

The installer keeps its own state in `~/.local/state/dotfiles`, outside the
checkout, so `git clean` or a fresh clone cannot remove it:

| Path | Contents |
| --- | --- |
| `backups/<run>/` | Files the installer replaced, at their paths relative to your home directory |
| `logs/<run>.log` | What each install run linked, backed up or skipped |

Each install run has one ID, a timestamp such as `20261028-181338`, shared by
its backup folder and log. For example, an existing `~/.config/git/ignore` is
saved as
`~/.local/state/dotfiles/backups/20261028-181338/.config/git/ignore`.
The installer never deletes backups.

To undo a run, read its log, remove the links it created and move the files
from its backup folder back to the same paths under your home directory.

### Local overrides

Machine-specific settings go in untracked files beside the linked ones. The
tracked configs load them last, so they override the defaults here:

| File | Loaded by |
| --- | --- |
| `~/.zshrc.local` | `.zshrc` |
| `~/.zprofile.local` | `.zprofile` |
| `~/.gitconfig.local` | `.gitconfig` |

If you have existing Zsh settings, review the backup of your old `.zshrc` or
`.zprofile` and move only the settings you need into these files.

### Git identity

No identity is tracked here. Keep a general identity in `~/.gitconfig.local`:

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
