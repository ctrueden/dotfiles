test "$DEBUG" && echo "[dotfiles] Loading plugin 'rust'..."

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
