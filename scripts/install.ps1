[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$homeDir = $HOME

function Set-DotfileLink {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Target
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "Missing source file: $Source"
    }

    $targetItem = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    if ($targetItem -and $targetItem.LinkType -eq 'SymbolicLink' -and
        $targetItem.Target -eq $Source) {
        Write-Host "Already linked: $Target"
        return
    }

    if (-not $PSCmdlet.ShouldProcess($Target, "Link to $Source")) {
        return
    }

    $parent = Split-Path -Parent $Target
    New-Item -ItemType Directory -Path $parent -Force | Out-Null

    if (Test-Path -LiteralPath $Target) {
        $stamp = Get-Date -Format 'yyyyMMddHHmmss'
        $backup = "$Target.dotfiles-backup-$stamp"
        $suffix = 0
        while (Test-Path -LiteralPath $backup) {
            $suffix++
            $backup = "$Target.dotfiles-backup-$stamp-$suffix"
        }
        Move-Item -LiteralPath $Target -Destination $backup
        Write-Host "Backed up $Target to $backup"
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    Write-Host "Linked $Target -> $Source"
}

$vscodeDir = Join-Path $env:APPDATA 'Code\User'
$documents = [Environment]::GetFolderPath('MyDocuments')
$profileDir = Join-Path $documents 'PowerShell'
$profilePath = Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1'

Set-DotfileLink (Join-Path $root 'home/.gitconfig') (Join-Path $homeDir '.gitconfig')
Set-DotfileLink (Join-Path $root 'home/.vimrc') (Join-Path $homeDir '_vimrc')
Set-DotfileLink (Join-Path $root 'home/starship.toml') (Join-Path $homeDir '.config/starship.toml')
Set-DotfileLink (Join-Path $root 'home/vscode/settings.json') (Join-Path $vscodeDir 'settings.json')
Set-DotfileLink (Join-Path $root 'home/powershell/Microsoft.PowerShell_profile.ps1') $profilePath
