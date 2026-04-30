#!/bin/bash
#
# XDG Base Directory Migration Script
# 
# This script migrates existing dotfiles to XDG-compliant locations.
# Review carefully before running!
#
# Usage: ./xdg-cleanup.sh [--dry-run]
#

set -euo pipefail

DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
  echo "=== DRY RUN MODE - No changes will be made ==="
  echo
fi

# XDG Base Directories
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Helper functions
mv_if_exists() {
  local src="$1"
  local dst="$2"
  
  if [ -e "$src" ] || [ -L "$src" ]; then
    if [ -e "$dst" ]; then
      echo "SKIP: $dst already exists, not overwriting"
    else
      echo "MOVE: $src -> $dst"
      if [ "$DRY_RUN" = false ]; then
        mkdir -p "$(dirname "$dst")"
        mv "$src" "$dst"
      fi
    fi
  fi
}

echo "XDG Base Directory Migration"
echo "============================"
echo
echo "This will move dotfiles to XDG-compliant locations:"
echo "  XDG_CONFIG_HOME = $XDG_CONFIG_HOME"
echo "  XDG_DATA_HOME   = $XDG_DATA_HOME"
echo "  XDG_STATE_HOME  = $XDG_STATE_HOME"
echo "  XDG_CACHE_HOME  = $XDG_CACHE_HOME"
echo

if [ "$DRY_RUN" = false ]; then
  read -p "Continue? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
  echo
fi

# --== Shell History & Cache ==--

echo "=== Shell History & Cache ==="
mv_if_exists "$HOME/.bash_history" "$XDG_STATE_HOME/bash/history"
mv_if_exists "$HOME/.zsh_history" "$XDG_STATE_HOME/zsh/history"
mv_if_exists "$HOME/.z" "$XDG_DATA_HOME/z/data"
mv_if_exists "$HOME/.zcompcache" "$XDG_CACHE_HOME/zsh/compcache"
mv_if_exists "$HOME/.zcompdump" "$XDG_CACHE_HOME/zsh/zcompdump"
mv_if_exists "$HOME/.lesshst" "$XDG_STATE_HOME/less/history"

# .zsh_sessions can be deleted (we disable it)
if [ -d "$HOME/.zsh_sessions" ]; then
  echo "DELETE: $HOME/.zsh_sessions (disabled via SHELL_SESSIONS_DISABLE)"
  if [ "$DRY_RUN" = false ]; then
    rm -rf "$HOME/.zsh_sessions"
  fi
fi

echo

# --== Vim ==--

echo "=== Vim ==="
mv_if_exists "$HOME/.vim" "$XDG_DATA_HOME/vim"
mv_if_exists "$HOME/.viminfo" "$XDG_STATE_HOME/vim/viminfo"
echo

# --== Version Managers & Runtimes ==--

echo "=== Version Managers & Runtimes ==="
mv_if_exists "$HOME/.cargo" "$XDG_DATA_HOME/cargo"
mv_if_exists "$HOME/.rustup" "$XDG_DATA_HOME/rustup"
mv_if_exists "$HOME/.nvm" "$XDG_DATA_HOME/nvm"
mv_if_exists "$HOME/.npm" "$XDG_CACHE_HOME/npm"
mv_if_exists "$HOME/.bun" "$XDG_DATA_HOME/bun"
mv_if_exists "$HOME/.gem" "$XDG_DATA_HOME/gem"
mv_if_exists "$HOME/.bundle" "$XDG_CONFIG_HOME/bundle"
echo

# --== Python Ecosystem ==--

echo "=== Python Ecosystem ==="
mv_if_exists "$HOME/.python_history" "$XDG_STATE_HOME/python/history"
mv_if_exists "$HOME/.ipython" "$XDG_CONFIG_HOME/ipython"
mv_if_exists "$HOME/.jupyter" "$XDG_CONFIG_HOME/jupyter"
mv_if_exists "$HOME/.conda" "$XDG_CACHE_HOME/conda"
mv_if_exists "$HOME/.condarc" "$XDG_CONFIG_HOME/conda/condarc"
mv_if_exists "$HOME/.mamba" "$XDG_DATA_HOME/mamba"
mv_if_exists "$HOME/.pixi" "$XDG_DATA_HOME/pixi"
mv_if_exists "$HOME/.keras" "$XDG_STATE_HOME/keras"
mv_if_exists "$HOME/.matplotlib" "$XDG_CONFIG_HOME/matplotlib"
mv_if_exists "$HOME/.pypirc" "$XDG_CONFIG_HOME/pip/pypirc"
echo

# --== Java/JVM Ecosystem ==--

echo "=== Java/JVM Ecosystem ==="
mv_if_exists "$HOME/.gradle" "$XDG_DATA_HOME/gradle"
mv_if_exists "$HOME/.sbt" "$XDG_DATA_HOME/sbt"
mv_if_exists "$HOME/.jgo" "$XDG_CACHE_HOME/jgo"
mv_if_exists "$HOME/.konan" "$XDG_DATA_HOME/konan"
mv_if_exists "$HOME/.kotlinc_history" "$XDG_STATE_HOME/kotlin/history"
mv_if_exists "$HOME/.jline-jython.history" "$XDG_STATE_HOME/jython/history"

# Note: .m2 is complex - Maven settings.xml may reference it
# We'll move .m2/repository but leave settings.xml management for later
if [ -d "$HOME/.m2/repository" ] && [ ! -e "$XDG_DATA_HOME/maven/repository" ]; then
  echo "MOVE: $HOME/.m2/repository -> $XDG_DATA_HOME/maven/repository"
  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$XDG_DATA_HOME/maven"
    mv "$HOME/.m2/repository" "$XDG_DATA_HOME/maven/repository"
  fi
fi

# Move settings.xml if it exists
if [ -f "$HOME/.m2/settings.xml" ]; then
  echo "MOVE: $HOME/.m2/settings.xml -> $XDG_CONFIG_HOME/maven/settings.xml"
  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$XDG_CONFIG_HOME/maven"
    mv "$HOME/.m2/settings.xml" "$XDG_CONFIG_HOME/maven/settings.xml"
  fi
fi

# Clean up .m2 if empty
if [ -d "$HOME/.m2" ]; then
  if [ -z "$(ls -A "$HOME/.m2")" ]; then
    echo "DELETE: $HOME/.m2 (now empty)"
    if [ "$DRY_RUN" = false ]; then
      rmdir "$HOME/.m2"
    fi
  else
    echo "KEEP: $HOME/.m2 (still contains files)"
  fi
fi

echo

# --== Java/Scientific Computing Caches ==--

#echo "=== Java Scientific Computing Caches ==="
#mv_if_exists "$HOME/.hawtjni" "$XDG_CACHE_HOME/hawtjni"
#mv_if_exists "$HOME/.javacpp" "$XDG_CACHE_HOME/javacpp"
#mv_if_exists "$HOME/.djl.ai" "$XDG_CACHE_HOME/djl"
#mv_if_exists "$HOME/.scijava" "$XDG_CACHE_HOME/scijava"
#mv_if_exists "$HOME/.icy" "$XDG_DATA_HOME/icy"
#mv_if_exists "$HOME/.trackmate" "$XDG_DATA_HOME/trackmate"
#mv_if_exists "$HOME/.scenery" "$XDG_DATA_HOME/scenery"
echo

# --== Database ==--

#echo "=== Database ==="
#mv_if_exists "$HOME/.sqlite_history" "$XDG_STATE_HOME/sqlite/history"
#echo

# --== Misc Apps ==--

echo "=== Misc Apps ==="
mv_if_exists "$HOME/.aspell.en.pws" "$XDG_CONFIG_HOME/aspell/en.pws"
mv_if_exists "$HOME/.aspell.en.prepl" "$XDG_CONFIG_HOME/aspell/en.prepl"
mv_if_exists "$HOME/.ansiweatherrc" "$XDG_CONFIG_HOME/ansiweather/config"
mv_if_exists "$HOME/.tldrc" "$XDG_CONFIG_HOME/tldr/config"
mv_if_exists "$HOME/.lldb" "$XDG_DATA_HOME/lldb"
echo

# --== AI/LLM Tools ==--

echo "=== AI/LLM Tools ==="
# These don't all support XDG yet, but let's organize what we can
mv_if_exists "$HOME/.ollama" "$XDG_DATA_HOME/ollama"
mv_if_exists "$HOME/.aider" "$XDG_DATA_HOME/aider"
mv_if_exists "$HOME/.aider.chat.history.md" "$XDG_DATA_HOME/aider/chat.history.md"
mv_if_exists "$HOME/.aider.input.history" "$XDG_STATE_HOME/aider/input.history"
echo "NOTE: .claude, .copilot, .codex, .gemini may not support XDG - check their docs"
echo

# --== Large Cache Directories ==--

echo "=== Large Cache Directories ==="
# These are big and could be deleted if needed
mv_if_exists "$HOME/.chromium-browser-snapshots" "$XDG_CACHE_HOME/chromium-snapshots"
echo

# --== Summary ==--

echo
echo "================================"
echo "Migration complete!"
echo
echo "Next steps:"
echo "1. Source your updated shell config: source ~/.zshrc"
echo "2. Verify env vars are set: env | grep XDG"
echo "3. Test that apps still work correctly"
echo
echo "Files NOT migrated (require manual review):"
echo "  ~/.netrc          - credentials, keep in place"
echo "  ~/.ssh/           - SSH keys, keep in place"
echo "  ~/.forward        - check if still needed"
echo "  ~/.plan           - consider symlinking to dotfiles"
echo "  ~/.ideavimrc      - consider symlinking to dotfiles"
echo "  ~/.vscode-oss/    - limited XDG support"
echo "  ~/.dendron*       - check app support"
echo "  ~/.logseq/        - check app support"
echo "  ~/.mastodon       - check app support"
echo "  ~/.vibe           - unknown app"
echo "  ~/.pcr-stats.json - unknown stats file"
echo "  ~/.claude*        - may not support XDG"
echo "  ~/.copilot        - may not support XDG"
echo "  ~/.codex          - may not support XDG"
echo "  ~/.gemini         - may not support XDG"
echo "  ~/.ollamassist    - check app support"
echo
if [ "$DRY_RUN" = true ]; then
  echo "This was a DRY RUN. Run without --dry-run to apply changes."
fi
