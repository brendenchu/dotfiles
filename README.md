# Dotfiles

Portable personal configuration for macOS, Linux, WSL, and Windows. The shared
configs are intentionally small; operating-system-specific setup stays in its
own script or package manifest.

## What is included

- Zsh configuration for macOS, Linux, and WSL
- PowerShell profile for native Windows
- Git aliases and safe defaults, without personal identity settings
- Vim defaults
- Shared VS Code settings
- Optional Starship prompt configuration
- Opt-in package installation for macOS, Debian/Ubuntu, and Windows with winget
- Link installers that keep backups of existing files

No system preferences are changed automatically. Terminal-app-specific
configuration is not included yet because it depends on which terminal you use.

## Install configuration

Clone this repository, then run the installer for your shell:

```sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

The Unix link installer supports macOS and Linux/WSL. It creates symlinks for
the shared configuration and backs up conflicting files next to their original
paths using a `.dotfiles-backup-<timestamp>` suffix. If the destination already
links to the repository file, it is left unchanged. Package installation
supports macOS with Homebrew and Debian/Ubuntu with apt.

On Windows, open PowerShell in the repository and run:

```powershell
.\scripts\install.ps1 -WhatIf
.\scripts\install.ps1
```

The Windows installer uses symbolic links. Enable Windows Developer Mode or
run PowerShell with permission to create symlinks. Existing destinations are
preserved as timestamped backups. The profile is installed for the current
PowerShell host.

To undo, remove only the links created by the installer. Restore any backup
files by moving them back to their original destinations. The installers do not
delete backups.

## Install packages (optional)

Package installation is separate from linking dotfiles and is never run by
default.

On macOS, install Homebrew first if needed, then run:

```sh
./scripts/install-packages.sh --dry-run
./scripts/install-packages.sh
```

On Debian/Ubuntu or WSL, run the same commands. The dry run prints the planned
packages without making changes; the regular run uses `apt-get` and may request
sudo authorization. Review `packages/apt.txt` first.

On Windows, review `packages/windows-winget.json`, then run:

```powershell
.\scripts\install-packages.ps1 -WhatIf
.\scripts\install-packages.ps1
```

The manifests provide a small baseline, not a requirement to install every
listed tool. Remove packages you do not want before running the installer.

## Customize

- Put private or machine-specific Zsh settings in `~/.zshrc.local`.
- Put private or machine-specific PowerShell settings in
  `Microsoft.PowerShell_profile.local.ps1` beside the installed profile.
- Add package choices to the platform manifest you use.
- Do not add credentials, private keys, tokens, or machine-specific service
  identities to this repository.

## Verify

Check the shell scripts with `sh -n scripts/install.sh` and
`sh -n scripts/install-packages.sh`. Use dry-run/WhatIf options before linking
files or installing packages.
Package installers make system changes and should be run only after reviewing
their manifests.
