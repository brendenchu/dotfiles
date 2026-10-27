Set-Alias ll Get-ChildItem
Set-Alias grep Select-String

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

$localProfile = Join-Path (Split-Path -Parent $PROFILE) 'Microsoft.PowerShell_profile.local.ps1'
if (Test-Path $localProfile) {
    . $localProfile
}
