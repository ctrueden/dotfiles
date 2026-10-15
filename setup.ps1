$dotfiles = Split-Path $MyInvocation.MyCommand.Path -Parent

# Install stub profiles (CurrentUserAllHosts) which source the profile.ps1 here,
# for both Windows PowerShell 5.1 and PowerShell 7+.
# Note: Documents may be redirected (e.g. by OneDrive), so ask for its real location.
$documents = [Environment]::GetFolderPath('MyDocuments')
foreach ($dir in 'WindowsPowerShell', 'PowerShell') {
    $profileDir = Join-Path $documents $dir
    New-Item -ItemType Directory -Force $profileDir | Out-Null
    $userProfile = Join-Path $profileDir 'profile.ps1'
    Write-Host "Writing $userProfile"
    Set-Content -Encoding UTF8 $userProfile @(
        "`$env:DOTFILES = `"$dotfiles`""
        ". `$env:DOTFILES\profile.ps1"
    )
}
