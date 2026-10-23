# Sets up the dotfiles on Windows, where this is the entry point: it runs
# setup.sh in Git Bash, then sets up PowerShell and Windows Terminal.
#
# To bootstrap a new machine, run it straight from GitHub:
#
#   irm https://raw.githubusercontent.com/ctrueden/dotfiles/main/setup.ps1 | iex
#
# which installs scoop and git, clones the dotfiles into
# ~/code/ctrueden/dotfiles, then runs the clone's copy of this script.

# Note: Piped into iex, the script has no file, and so is bootstrapping.
if (-not $PSCommandPath) {
    # Both scoop's installer and the cloned scripts need local scripts allowed.
    if ((Get-ExecutionPolicy -Scope CurrentUser) -notin 'RemoteSigned', 'Unrestricted', 'Bypass') {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    }
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
    }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        scoop install git
    }
    $clone = "$HOME\code\ctrueden\dotfiles"
    if (-not (Test-Path $clone)) {
        git clone https://github.com/ctrueden/dotfiles $clone
    }
    & "$clone\setup.ps1"
    return
}

$dotfiles = Split-Path $PSCommandPath -Parent

# Git for Windows, from scoop, or else from its own installer.
$git = "$HOME\scoop\apps\git\current"
if (-not (Test-Path $git)) {
    $git = Split-Path (Split-Path (Get-Command git).Source)
}

# Run setup.sh, which tells from this variable that it need not defer to here.
$env:DOTFILES_SETUP_PS1 = 1
& "$git\bin\bash.exe" "$($dotfiles -replace '\\', '/')/setup.sh"
Remove-Item Env:DOTFILES_SETUP_PS1

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

# Install a stub psmux (tmux for Windows) config, which sources the shared
# tmux/tmux.conf, then tmux/fkeys.conf and tmux/psmux.conf, and binds F5 to
# reload itself.
# Note: psmux leaves #{current_file} empty while reading the config at startup,
# so the stub sets the @tmux-dir that tmux.conf derives from it.
# Note: Its panes start Git's zsh (else bash) directly, without the launcher
# that Git Bash uses, so the stub sets what that launcher would: the full
# Windows PATH, and the MSYSTEM matching this build of Git.
$shell = "$git\usr\bin\zsh.exe"
if (-not (Test-Path $shell)) { $shell = "$git\usr\bin\bash.exe" }
$msystem = if (Test-Path "$git\ucrt64") { 'UCRT64' } else { 'MINGW64' }
$unixDotfiles = $dotfiles -replace '\\', '/'
$psmuxConf = "$HOME\.psmux.conf"
Write-Host "Writing $psmuxConf"
[IO.File]::WriteAllText($psmuxConf, ((@(
    '# Written by dotfiles/setup.ps1.'
    "set -g default-shell `"$($shell -replace '\\', '/')`""
    'set-environment -g MSYS2_PATH_TYPE inherit'
    "set-environment -g MSYSTEM $msystem"
    "source-file `"$unixDotfiles/tmux/tmux.conf`""
    "set -g @tmux-dir `"$unixDotfiles/tmux`""
    "source-file `"$unixDotfiles/tmux/fkeys.conf`""
    "source-file `"$unixDotfiles/tmux/psmux.conf`""
    'bind-key -N "Reload the tmux configuration" -n F5 source-file ~/.psmux.conf'
) -join "`n") + "`n"))

# Install a Windows Terminal fragment, adding Git Bash (and zsh, once there)
# profiles, and giving the built-in profiles Hack Nerd Font.
# Note: A fragment can neither choose the default profile nor set defaults for
# all profiles, so those remain for the user, in Terminal's settings.
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
