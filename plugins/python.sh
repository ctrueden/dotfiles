test "$DEBUG" && echo "[dotfiles] Loading plugin 'python'..."

pypath() { python -c 'import sys; print("\n".join(sys.path))'; }

# --== uv ==--

if [ ! -x "$(command -v uv)" ]; then
  # Install uv via pip if possible.
  if [ -x "$(command -v pip)" ]; then
    pip install --user uv
  fi
fi

if [ -x "$(command -v uv)" ]; then
  # Enable uv shell completion.
  eval "$(uv generate-shell-completion zsh)"
fi
