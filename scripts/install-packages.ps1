[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'
$manifest = Join-Path (Split-Path -Parent $PSScriptRoot) 'packages/windows-winget.json'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'winget is required. Install or update App Installer, then rerun this script.'
}

if ($PSCmdlet.ShouldProcess($manifest, 'Install packages from winget manifest')) {
    & winget import --import-file $manifest --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "winget import failed with exit code $LASTEXITCODE"
    }
}
