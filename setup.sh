#!/bin/sh

set -e

# -- Global variables --

CONFIG_DIR=$(cd "$(dirname $0)"; pwd)
# NB: Git Bash's pwd gives C:/... or /c/..., depending on how bash started;
# settle on one, so the stubs written below stay the same from run to run.
! command -v cygpath >/dev/null || CONFIG_DIR=$(cygpath -u "$CONFIG_DIR")
# Note: Tool installers invoked below (e.g. bin/packages/install-*) need this,
# and on a fresh machine no shell has exported it yet.
export DOTFILES="$CONFIG_DIR"
cd

OS_NAME=$(uname)
STAMP=$(date +%Y%m%dT%H%M%S)
case "$OS_NAME" in
  MINGW*|MSYS*|CYGWIN*) WINDOWS=1 ;;
  *) WINDOWS= ;;
esac

# -- Functions --

# Clears away the given file, backing it up first if needed.
# If it is a real file (not a symlink), it is renamed.
# Or if the file is a symlink, it is simply deleted.
clear_file() {
  f="$1"
  if [ -h "$f" ]; then
    (set -x; rm "$f")
  elif [ -f "$f" ]; then
    bk="$f.$STAMP"
    (set -x; mv "$f" "$bk")
  fi
}

# Copies the given source to the specified destination.
# Does nothing if files match; otherwise, replaces the original file.
install_file() {
  src="$1"
  dest="$2"
  diff "$src" "$dest" > /dev/null 2>&1 ||
    (clear_file "$dest"; set -x; cp "$src" "$dest")
}

# Symlinks the given source to the specified destination.
# Note: Windows restricts creating symlinks, so there it copies the file
# instead. A hard link would be no better: it detaches silently whenever git
# replaces the file in the working copy.
link_file() {
  src="$1"
  dest="$2"
  if [ -n "$WINDOWS" ]; then
    install_file "$src" "$dest"
    return
  fi
  clear_file "$dest"
  (set -x; ln -sf "$src" "$dest")
}

# Writes a stub to the given destination, whose lines are the remaining
# arguments, replacing what is there unless it already matches.
stub_file() {
  stub_dest="$1"; shift
  stub=$(mktemp)
  printf '%s\n' "$@" > "$stub"
  install_file "$stub" "$stub_dest"
  rm -f "$stub"
}

# Removes a link (on Windows, a copy) that this script once made,
# which a stub or setting now replaces.
unlink_file() {
  if [ -h "$1" ] || { [ -n "$WINDOWS" ] && [ -f "$1" ]; }; then
    (set -x; rm "$1")
  fi
}

# -- Main --

echo
echo "--> Linking up your dotfiles..."

# NB: We use stub files for some shell config files, to maintain support for
# systems that do not support proper symlinks -- especially MSysGit on Windows.
# It also enables command-line tools such as conda to mess with these
# files as they desire without dirtying the dotfiles working copy.

# ~/.bashrc
for cfgFile in bashrc bash_profile zshrc
do
  # Skip if the file already sources the dotfiles -- it may have tool-managed
  # blocks appended (conda init, nvm, etc.) that we must not clobber.
  grep -qF '$DOTFILES' ".$cfgFile" 2>/dev/null && continue
  tmpFile="$CONFIG_DIR/$cfgFile.stub"
  rm -f "$tmpFile"
  if [ "$cfgFile" = "bashrc" ]; then
    # Bash interactive guard: prevent non-interactive sessions (e.g., gdm3 login)
    # from sourcing bashrc, which would leak exports into the X session environment.
    echo '[ -z "$PS1" ] && return # Continue only if shell is interactive.' >> "$tmpFile"
  fi
  echo "export DOTFILES=\"$CONFIG_DIR\"" >> "$tmpFile"
  echo ". \"\$DOTFILES/$cfgFile\"" >> "$tmpFile"
  install_file "$tmpFile" ".$cfgFile"
  rm -f "$tmpFile"
done

# ~/.gitconfig
# NB: We use a stub for .gitconfig so that it can be extended with a
# [user] section without causing git to see the gitconfig here as dirty.
# Skip if it already exists -- it likely has a [user] section appended.
if [ ! -f .gitconfig ]; then
  GITCONFIG_STUB="$CONFIG_DIR/gitconfig.stub"
  echo '[include]' > "$GITCONFIG_STUB"
  printf "\tpath = $CONFIG_DIR/gitconfig\n" >> "$GITCONFIG_STUB"
  install_file "$GITCONFIG_STUB" .gitconfig
  rm -f "$GITCONFIG_STUB"
fi

# ~/.ssh/config
# NB: We write out a starter .ssh/config so that it can be extended with
# additional configuration without causing git to see the file as dirty.
SSHCONFIG=.ssh/config
if [ ! -f "$SSHCONFIG" ]
then
  mkdir -p .ssh
  for f in "$CONFIG_DIR/ssh.d"/*
  do
    (set -x; echo "Include $f" >> "$SSHCONFIG")
  done
fi

mkdir -p .config

# ~/.config/starship.toml
# NB: The shells set STARSHIP_CONFIG to the dotfiles' copy instead.
unlink_file .config/starship.toml

# ~/.config/jgo.conf
# NB: jgo has no way to read its config from elsewhere, nor to include it.
link_file "$CONFIG_DIR/jgo.conf" .config/jgo.conf

# ~/.config/byobu/.tmux.conf [not Windows, which lacks byobu]
# NB: We link only this file, not the whole directory, because byobu
# writes its own state and settings into ~/.config/byobu.
if [ -z "$WINDOWS" ]; then
  mkdir -p .config/byobu
  link_file "$CONFIG_DIR/byobu/tmux.conf" .config/byobu/.tmux.conf
  link_file "$CONFIG_DIR/byobu/palette.sh" .config/byobu/palette.sh
  link_file "$CONFIG_DIR/byobu/notes.tmux" .config/byobu/notes.tmux
  link_file "$CONFIG_DIR/byobu/status" .config/byobu/status
  link_file "$CONFIG_DIR/byobu/statusrc" .config/byobu/statusrc
  mkdir -p .config/byobu/bin
  for f in "$CONFIG_DIR"/byobu/bin/*; do
    link_file "$f" ".config/byobu/bin/$(basename "$f")"
  done
fi

# ~/.mrconfig
# NB: A stub lets `mr register` add to it without dirtying the dotfiles.
stub_file .mrconfig "include = cat \"$CONFIG_DIR/mrconfig\""

# ~/.config/mr
mkdir -p .config/mr
stub_file .config/mr/essential "include = cat \"$CONFIG_DIR/mrconfig.d/essential\""

# ~/.config/wd/warprc
# NB: zshrc sets WD_CONFIG to the dotfiles' copy instead.
unlink_file .config/wd/warprc

# ~/.vim/vimrc
mkdir -p .vim
stub_file .vim/vimrc "source $CONFIG_DIR/vimrc"

# ~/.XCompose [not Windows, which lacks X]
test -n "$WINDOWS" || link_file "$CONFIG_DIR/XCompose" .XCompose

# ~/Library/KeyBindings [macOS]
case "$(uname)" in
  Darwin)
    cd Library
    link_file "$CONFIG_DIR/KeyBindings" KeyBindings
    cd ..
    ;;
esac

# PowerShell profiles [Windows]
case "$(uname)" in
  MINGW*|MSYS*|CYGWIN*)
    (set -x; powershell -NoProfile -ExecutionPolicy Bypass \
      -File "$(cygpath -w "$CONFIG_DIR/setup.ps1")")
    ;;
esac

echo
echo "--> Installing tools..."

# Which opt-in sections of the packages manifest this machine wants. Asked
# once, then remembered; edit the file to change it.
profile="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/sections"
if [ ! -f "$profile" ] && [ -t 0 ]; then
  echo "What... is your quest?"
  sed -n "s/^#   \([a-z]*  \)/  \1/p" "$CONFIG_DIR/packages"
  printf "Opt-in package sections, space-separated [none]: "
  read quest
  mkdir -p "$(dirname "$profile")"
  printf "%s\n" $quest > "$profile"
fi

# Packages from the manifest (neovim, starship, byobu, fzf, AI TUIs, etc.).
# Note: The rest of setup does not depend on these, so a failure is not fatal.
"$CONFIG_DIR/bin/system/install-packages" ||
  echo "Warning: install-packages failed; continuing setup." >&2

# byobu -- tmux with batteries (installed via packages; fzf powers its command palette)
# Note: byobu-enable hooks only login shells (e.g. ssh, iTerm2);
# zshrc launches byobu for non-login local terminals (e.g. Guake).
command -v byobu-enable >/dev/null 2>&1 && byobu-enable

# Guake -- free up Ctrl+F1..F12 for byobu, rather than switching Guake tabs.
if gsettings list-schemas 2>/dev/null | grep -qx guake.keybindings.local; then
  for i in $(seq 1 10); do
    gsettings set guake.keybindings.local switch-tab$i ''
  done
  gsettings set guake.keybindings.local switch-tab-last ''
fi

# kickstart.nvim requires nvim 0.10+. Ubuntu 24.04 apt ships 0.9.x; skip
# gracefully there rather than installing a config that errors on startup.
# Ubuntu 26.04 LTS (due ~April 2026) will ship 0.10+.
nvim_ok() {
  nvim --version 2>/dev/null | head -1 | grep -qE '^NVIM v(0\.(1[0-9]|[2-9][0-9])|[1-9])'
}

# ~/.config/nvim -- kickstart.nvim + custom plugins from dotfiles
# NB: Neovim on Windows reads its config from %LOCALAPPDATA%\nvim instead.
if [ -n "$WINDOWS" ]; then
  NVIM_CONFIG_DIR="$(cygpath -u "$LOCALAPPDATA")/nvim"
  # Move the config from where earlier versions of this script put it.
  if [ -d "$HOME/.config/nvim" ] && [ ! -e "$NVIM_CONFIG_DIR" ]; then
    (set -x; mv "$HOME/.config/nvim" "$NVIM_CONFIG_DIR")
  fi
else
  NVIM_CONFIG_DIR="$HOME/.config/nvim"
fi
NVIM_CONFIG="$NVIM_CONFIG_DIR/init.lua"
if command -v nvim >/dev/null 2>&1 && nvim_ok && [ ! -d "$NVIM_CONFIG_DIR" ]; then
  echo "Installing kickstart.nvim into $NVIM_CONFIG_DIR..."
  git clone https://github.com/nvim-lua/kickstart.nvim "$NVIM_CONFIG_DIR"
fi
if command -v nvim >/dev/null 2>&1 && nvim_ok && [ -d "$NVIM_CONFIG_DIR" ]; then
  # Stub dotfiles/nvim/init.lua into lua/custom/plugins/, which kickstart's
  # custom.plugins loads. It loads everything else under dotfiles/nvim, so
  # files can come and go there without rerunning this script.
  # NB: Native Neovim on Windows needs a Windows path.
  nvim_dir="$CONFIG_DIR/nvim"
  test -z "$WINDOWS" || nvim_dir=$(cygpath -m "$nvim_dir")
  mkdir -p "$NVIM_CONFIG_DIR/lua/custom/plugins"
  stub_file "$NVIM_CONFIG_DIR/lua/custom/plugins/dotfiles.lua" \
    "-- Written by dotfiles/setup.sh." \
    "dofile '$nvim_dir/init.lua'"

  # Remove the per-file links that the stub replaces.
  for _f in "$CONFIG_DIR/nvim/plugins/"*.lua; do
    unlink_file "$NVIM_CONFIG_DIR/lua/custom/plugins/$(basename "$_f")"
  done
  for _f in "$CONFIG_DIR/nvim/ftplugin/"*.lua; do
    unlink_file "$NVIM_CONFIG_DIR/ftplugin/$(basename "$_f")"
  done
  test ! -h "$NVIM_CONFIG_DIR/after" || (set -x; rm "$NVIM_CONFIG_DIR/after")
  unlink_file "$NVIM_CONFIG_DIR/lua/custom/options.lua"
  perl -0 -i -pe "s|-- Load local overrides \(options, mappings, etc\.\) from dotfiles if present\npcall\(require, 'custom\.options'\)\n\n||" "$NVIM_CONFIG"

  # -- BEGIN blink.cmp OVERRIDES --

  # Set blink.cmp to use rust fuzzy matcher rather than lua (idempotent).
  perl -i -pe "s|fuzzy = { implementation = 'lua' },|fuzzy = { implementation = 'prefer_rust_with_warning' },|" "$NVIM_CONFIG"

  # Add blink.cmp keymap overrides: Tab/C-./C-Space/CR (idempotent).
  grep -qF "'<Tab>'" "$NVIM_CONFIG" || \
    perl -i -pe "s|(preset = 'default',)|\$1\n      ['<Tab>'] = { 'accept', 'fallback' },\n      ['<C-.>'] = { 'show', 'accept', 'fallback' },\n      ['<C-Space>'] = { 'show', 'fallback' },\n      ['<CR>'] = { 'accept', 'fallback' },|" "$NVIM_CONFIG"

  # Disable blink.cmp auto-trigger on insert and keyword (idempotent).
  grep -qF 'show_on_keyword' "$NVIM_CONFIG" || \
    perl -i -pe "s|(documentation = \{ auto_show = false, auto_show_delay_ms = 500 \},)|\$1\n      trigger = { show_on_insert_on_trigger_character = false, show_on_keyword = false },|" "$NVIM_CONFIG"

  # Add buffer source to blink.cmp defaults (idempotent).
  perl -i -pe "s|default = \{ 'lsp', 'path', 'snippets' \},|default = { 'lsp', 'path', 'snippets', 'buffer' },|" "$NVIM_CONFIG"

  # -- END blink.cmp OVERRIDES --

  # Uncomment the custom plugins import line (idempotent).
  perl -i -pe "s/-- ((require|\{ import =) 'custom\.plugins')/\$1/" "$NVIM_CONFIG"

  # Enable the pyright LSP server (idempotent).
  perl -i -pe "s/-- (pyright = \{\},)/\$1/" "$NVIM_CONFIG"

  # Have mason-tool-installer install the Java toolchain (jdtls + debug/test
  # bundles used by ftplugin/java.lua) and bash-language-server (idempotent).
  grep -qF "'java-debug-adapter'" "$NVIM_CONFIG" || \
    perl -i -pe "s|(-- You can add other tools here that you want Mason to install)|\$1\n    'jdtls',\n    'java-debug-adapter',\n    'java-test',\n    'bash-language-server',|" "$NVIM_CONFIG"

  # Disable delve plugin auto-install (idempotent).
  perl -i -pe "s/^(\s*)('delve',)/\$1-- \$2/" "$NVIM_CONFIG_DIR/lua/kickstart/plugins/debug.lua"

  # Set nerd font flag as appropriate.
  case "$(uname)" in
    Linux|Darwin|MINGW*|MSYS*|CYGWIN*)
      perl -i -pe "s|vim.g.have_nerd_font = false|vim.g.have_nerd_font = true|" "$NVIM_CONFIG"
      ;;
  esac
fi

# ~/.vim/bundle/Vundle.vim -- vim plugin manager (fallback for systems without nvim)
if ! command -v nvim >/dev/null 2>&1 && [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
  command -v vim >/dev/null 2>&1 &&
    vim -c "execute 'PluginInstall' | qa"
fi

# Claude Code -- AI coding assistant
# Note: The packages manifest installs it on macOS and Windows; this covers
# the rest, e.g. Linux, or Windows without scoop.
# Note: We use curl|sh -- if the claude.ai domain were compromised, running
# claude at all would be equally dangerous, so this is an acceptable risk.
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  case "$(uname)" in
    # Note: install.sh refuses to run on Windows; it has a PowerShell twin.
    MINGW*|MSYS*|CYGWIN*)
      powershell -NoProfile -ExecutionPolicy Bypass -Command 'irm https://claude.ai/install.ps1 | iex' ;;
    *) curl -fsSL https://claude.ai/install.sh | bash ;;
  esac
fi

# Note: We ask whenever the identity is unset, rather than when .gitconfig is
# absent, since the stub written above has already created .gitconfig.
if [ -z "$(git config --global user.email)" ] && [ -t 0 ]; then
  echo
  echo "--> Personalizing your experience..."
  cat "$CONFIG_DIR/old-man.txt"
  echo "Answer me these questions three, ere the other side ye see!"
  printf "What... is your full name? "
  read committer_name
  printf "What... is your email address? "
  read committer_email
  echo "What... is the airspeed velocity of an unladen --"
  echo "The people responsible for this shell script have been sacked."
  (set -x; git config --global user.name "$committer_name")
  (set -x; git config --global user.email "$committer_email")
  (clear_file .forward; set -x; echo "$committer_email" > .forward)

  # ~/.plan
  test "$committer_name" = "Curtis Rueden" && link_file "$CONFIG_DIR/plan" .plan
fi

echo
echo "--> Done! Now open a new terminal. :-)"
