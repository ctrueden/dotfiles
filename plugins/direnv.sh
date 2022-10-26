test "$DEBUG" && echo "[dotfiles] Loading plugin 'direnv'..."

# Enable direnv if installed.
if command -v direnv >/dev/null
then
  eval "$(direnv hook "$(shell_name)")"
fi
