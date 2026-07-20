#!/bin/sh

set -e

# -- Global variables --

CONFIG_DIR=$(cd "$(dirname $0)"; pwd)
cd

OS_NAME=$(uname)
STAMP=$(date +%Y%m%dT%H%M%S)

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
link_file() {
  src="$1"
  dest="$2"
  clear_file "$dest"
  case "$(uname)" in
    # Note: We cannot use `ln -s` nor `mklink` due to Windows
    # restricting creation of symbolic links by default.
    # And we can only hard link a file that actually exists.
    MINGW*) test ! -f "$src" || (set -x; ln "$src" "$dest") ;;
    *) (set -x; ln -sf "$src" "$dest") ;;
  esac
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
link_file "$CONFIG_DIR/starship.toml" .config/starship.toml

# ~/.config/jgo.conf
link_file "$CONFIG_DIR/jgo.conf" .config/jgo.conf

# ~/.mrconfig
link_file "$CONFIG_DIR/mrconfig" .mrconfig

# ~/.config/mr
mkdir -p .config/mr
link_file "$CONFIG_DIR/mrconfig.d/essential" .config/mr/essential

# ~/.config/wd
mkdir -p .config/wd
link_file "$CONFIG_DIR/warprc" .config/wd/warprc

# ~/.vim/vimrc
mkdir -p .vim
link_file "$CONFIG_DIR/vimrc" .vim/vimrc

# ~/.XCompose
link_file "$CONFIG_DIR/XCompose" .XCompose

# ~/bin
# NB: It's OK if the sources don't exist yet, or ever.
# This step just makes them available on the path,
# in case they do get cloned locally into ~/code.
mkdir -p bin
link_file "../code/git/git-diff-blame/git-diff-blame" bin/git-diff-blame
link_file "../code/git/git-recover/git-recover" bin/git-recover
link_file "../code/util/icat/icat" bin/icat

# ~/Library/KeyBindings [macOS]
case "$(uname)" in
  Darwin)
    cd Library
    link_file "$CONFIG_DIR/KeyBindings" KeyBindings
    cd ..
    ;;
esac

echo
echo "--> Installing tools..."

# neovim and system dependencies.
case "$(uname)" in
  Linux)
    if ! command -v nvim >/dev/null 2>&1; then
      echo "Installing neovim and dependencies..."
      sudo apt-get update &&
      sudo apt-get install -y make gcc ripgrep fd-find unzip xclip neovim
    fi
    ;;
  Darwin)
    if ! command -v nvim >/dev/null 2>&1; then
      echo "Installing neovim and dependencies..."
      brew install gcc ripgrep neovim
    fi
    ;;
esac

# starship -- cross-shell prompt
case "$(uname)" in
  Linux)
    command -v starship >/dev/null 2>&1 || {
      echo "Installing starship..."
      if apt-cache show starship >/dev/null 2>&1; then
        # Available as a package (Ubuntu 25.04+).
        sudo apt-get install -y starship
      else
        # Fall back to curl-based installer.
        curl -sS https://starship.rs/install.sh | sh
      fi
    }
    ;;
  Darwin)
    command -v starship >/dev/null 2>&1 || {
      echo "Installing starship..."
      brew install starship
    }
    ;;
esac

# Hack Nerd Font -- required for starship prompt glyphs and nvim icons
case "$(uname)" in
  Linux)
    if [ ! -d "$HOME/.fonts/Hack" ]; then
      echo "Installing Hack Nerd Font..."
      mkdir -p "$HOME/.fonts/Hack"
      curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip \
        -o /tmp/Hack.zip &&
      unzip -o /tmp/Hack.zip -d "$HOME/.fonts/Hack" &&
      rm /tmp/Hack.zip &&
      command -v fc-cache >/dev/null 2>&1 || {
        echo "Installing fontconfig utilities..."
        sudo apt-get install -y fontconfig
      }
      echo "Rebuilding font cache..."
      fc-cache -f
    fi
    ;;
  Darwin)
    if ! brew list --cask font-hack-nerd-font >/dev/null 2>&1; then
      echo "Installing Hack Nerd Font..."
      brew install --cask font-hack-nerd-font
    fi
    ;;
esac

# kickstart.nvim requires nvim 0.10+. Ubuntu 24.04 apt ships 0.9.x; skip
# gracefully there rather than installing a config that errors on startup.
# Ubuntu 26.04 LTS (due ~April 2026) will ship 0.10+.
nvim_ok() {
  nvim --version 2>/dev/null | head -1 | grep -qE '^NVIM v(0\.(1[0-9]|[2-9][0-9])|[1-9])'
}

# ~/.config/nvim -- kickstart.nvim + custom plugins from dotfiles
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_CONFIG="$NVIM_CONFIG_DIR/init.lua"
if command -v nvim >/dev/null 2>&1 && nvim_ok && [ ! -d "$NVIM_CONFIG_DIR" ]; then
  echo "Installing kickstart.nvim into $NVIM_CONFIG_DIR..."
  git clone https://github.com/nvim-lua/kickstart.nvim "$NVIM_CONFIG_DIR"
fi
if command -v nvim >/dev/null 2>&1 && nvim_ok && [ -d "$NVIM_CONFIG_DIR" ]; then
  # Symlink each plugin file from dotfiles/nvim/plugins/ into lua/custom/plugins/
  # so kickstart's custom.plugins import picks them up. Per-file symlinks are
  # used (not a directory symlink) because kickstart's clone already contains
  # lua/custom/plugins/ as a real directory, which ln -sf cannot replace.
  mkdir -p "$NVIM_CONFIG_DIR/lua/custom/plugins"
  for _f in "$CONFIG_DIR/nvim/plugins/"*.lua; do
    link_file "$_f" "$NVIM_CONFIG_DIR/lua/custom/plugins/$(basename "$_f")"
  done

  # Symlink dotfiles/nvim/after/ so our after/plugin/*.lua files run after all
  # plugins load -- reliable for config that must execute after everything else.
  link_file "$CONFIG_DIR/nvim/after" "$NVIM_CONFIG_DIR/after"

  # Symlink each ftplugin file (filetype-specific config, e.g. nvim-jdtls).
  mkdir -p "$NVIM_CONFIG_DIR/ftplugin"
  for _f in "$CONFIG_DIR/nvim/ftplugin/"*.lua; do
    link_file "$_f" "$NVIM_CONFIG_DIR/ftplugin/$(basename "$_f")"
  done

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

  # Disable delve plugin auto-install (idempotent).
  perl -i -pe "s/^(\s*)('delve',)/\$1-- \$2/" "$NVIM_CONFIG_DIR/lua/kickstart/plugins/debug.lua"

  # Symlink options override file and hook it into nvim config (idempotent).
  link_file "$CONFIG_DIR/nvim/options.lua" "$NVIM_CONFIG_DIR/lua/custom/options.lua"
  grep -qF 'custom.options' "$NVIM_CONFIG" || \
    perl -i -pe "s|-- The line beneath this is called .modeline.|-- Load local overrides (options, mappings, etc.) from dotfiles if present\npcall(require, 'custom.options')\n\n\$&|" "$NVIM_CONFIG"

  # Set nerd font flag as appropriate.
  case "$(uname)" in
    Linux|Darwin)
      perl -i -pe "s|vim.g.have_nerd_font = false|vim.g.have_nerd_font = true|" "$NVIM_CONFIG"
      ;;
  esac
fi

# tree-sitter-cli via npm (apt package is 0.20.x, too old for nvim-treesitter which requires 0.22+)
if command -v nvim >/dev/null 2>&1 && ! command -v tree-sitter >/dev/null 2>&1; then
  if command -v npm >/dev/null 2>&1; then
    echo "Installing tree-sitter-cli via npm..."
    npm install -g tree-sitter-cli
  fi
fi

# ~/.vim/bundle/Vundle.vim -- vim plugin manager (fallback for systems without nvim)
if ! command -v nvim >/dev/null 2>&1 && [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
  command -v vim >/dev/null 2>&1 &&
    vim -c "execute 'PluginInstall' | qa"
fi

# uv -- Python package manager
if ! command -v uv >/dev/null 2>&1; then
  echo "Installing uv..."
  if command -v pip >/dev/null 2>&1; then
    _pip=pip
  elif command -v pip3 >/dev/null 2>&1; then
    _pip=pip3
  else
    _pip=
  fi
  if [ -n "$_pip" ]; then
    "$_pip" install --user uv ||
    "$_pip" install --break-system-packages --user uv
  fi
fi

# Claude Code -- AI coding assistant
# Note: We use curl|sh -- if the claude.ai domain were compromised, running
# claude at all would be equally dangerous, so this is an acceptable risk.
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

# AI coding assistant TUIs via npm.
if command -v npm >/dev/null 2>&1; then
  install_npm_tool() {
    command -v "$1" >/dev/null 2>&1 || {
      echo "Installing $1..."
      npm install -g "$2"
    }
  }
  install_npm_tool copilot   @github/copilot
  #install_npm_tool claude   @anthropic-ai/claude-code
  install_npm_tool codex     @openai/codex
  #install_npm_tool gemini    @google/gemini-cli
  #install_npm_tool grok     @vibe-kit/grok-cli
  install_npm_tool crush     @charmland/crush
  install_npm_tool opencode  opencode-ai
  install_npm_tool kilocode  @kilocode/cli
  #install_npm_tool nanocoder @nanocollective/nanocoder
fi

if [ ! -f .gitconfig ]; then
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
