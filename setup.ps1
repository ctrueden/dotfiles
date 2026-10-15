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

# Install a Windows Terminal fragment, adding Git Bash (and zsh, once there)
# profiles, and giving the built-in profiles Hack Nerd Font.
# Note: A fragment can neither choose the default profile nor set defaults for
# all profiles, so those remain for the user, in Terminal's settings.
$git = "$HOME\scoop\apps\git\current"
$font = @{ face = 'Hack Nerd Font' }
$icon = "$git\usr\share\git\git-for-windows.ico"
$profiles = @(
    @{
        guid = '{ed6382fe-33da-4586-bce3-ac137baabe66}'
        name = 'Git Bash'
        commandline = "`"$git\bin\bash.exe`" -i -l"
        icon = $icon
        startingDirectory = '%USERPROFILE%'
        font = $font
    }
    @{ updates = '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}'; font = $font } # Windows PowerShell
    @{ updates = '{574e775e-4f2a-5b96-ac1e-a2962a402336}'; font = $font } # PowerShell 7
    @{ updates = '{0caa0dad-35be-5f56-a8ff-afceeeaa6101}'; font = $font } # Command Prompt
)
if (Test-Path "$git\usr\bin\zsh.exe") {
    # Note: bin\bash.exe sets up Git's environment, which zsh then inherits.
    $profiles += @{
        guid = '{cb04108c-af95-47b6-ba1c-401efd20c28a}'
        name = 'Zsh'
        commandline = "`"$git\bin\bash.exe`" -c `"exec zsh -l`""
        icon = $icon
        startingDirectory = '%USERPROFILE%'
        font = $font
    }
}
$fragmentDir = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\Fragments\dotfiles"
New-Item -ItemType Directory -Force $fragmentDir | Out-Null
$fragment = Join-Path $fragmentDir 'dotfiles.json'
Write-Host "Writing $fragment"
[IO.File]::WriteAllText($fragment, (@{ profiles = $profiles } | ConvertTo-Json -Depth 4))
Write-Host "In Windows Terminal's settings, you may wish to make Git Bash or Zsh"
Write-Host "the default profile, and Hack Nerd Font the default font."
