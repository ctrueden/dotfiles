test "$DEBUG" && echo "[dotfiles] Loading plugin 'xdg'..."

# --== XDG Base Directories ==--
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Ensure directories exist
mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"

# --== Shell ==--

export HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

# Disable macOS zsh session persistence
export SHELL_SESSIONS_DISABLE=1

# zsh completion cache
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "$(dirname "$ZSH_COMPDUMP")"

# z jump data
export _Z_DATA="$XDG_DATA_HOME/z/data"
mkdir -p "$(dirname "$_Z_DATA")"

# less history
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
mkdir -p "$(dirname "$LESSHISTFILE")"

# --== Version Managers & Language Runtimes ==--

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Node.js
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

# Bun
export BUN_INSTALL="$XDG_DATA_HOME/bun"

# Ruby
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# --== Python ==--

export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
mkdir -p "$(dirname "$PYTHON_HISTORY")"

export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_DATA_DIR="$XDG_DATA_HOME/jupyter"

# Conda
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export CONDA_PKGS_DIRS="$XDG_CACHE_HOME/conda/pkgs"

# Mamba
export MAMBA_ROOT_PREFIX="$XDG_DATA_HOME/mamba"

# Pixi
export PIXI_HOME="$XDG_DATA_HOME/pixi"

# Keras
export KERAS_HOME="$XDG_STATE_HOME/keras"

# Matplotlib
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"

# --== Java/JVM ==--

export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# SBT - set via Java options
export SBT_OPTS="${SBT_OPTS:+$SBT_OPTS }-Dsbt.global.base=$XDG_DATA_HOME/sbt"

# jgo
export JGO_CACHE_DIR="$XDG_CACHE_HOME/jgo"

# Kotlin Native
export KONAN_DATA_DIR="$XDG_DATA_HOME/konan"

# --== Git ==--

# Note: ~/.gitconfig stays in place but can reference XDG locations internally

# --== Database ==--

export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite/history"
mkdir -p "$(dirname "$SQLITE_HISTORY")"

# --== Misc Apps ==--

# Aspell
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl"

# tldr
export TLDR_CACHE_DIR="$XDG_CACHE_HOME/tldr"

# Ollama models
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
