$dotfiles = Split-Path $MyInvocation.MyCommand.Path -Parent

# Install a stub profile (CurrentUserCurrentHost) which sources the profile.ps1 here.
$profileDir = "$HOME\Documents\WindowsPowerShell"
mkdir $profileDir -ErrorAction SilentlyContinue
$userProfile = "$profileDir\profile.ps1"
echo "`$env:DOTFILES = \"$dotfiles\"" > $userProfile
echo ". `$env:DOTFILES\profile.ps1" >> $userProfile
