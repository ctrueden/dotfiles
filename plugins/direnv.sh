test "$DEBUG" && echo "[dotfiles] Loading plugin $(basename "$0")..."

# Enable direnv if installed.
if which direnv >/dev/null 2>/dev/null
then
  eval "$(direnv hook "$(ps -o comm= $$)")"
fi
