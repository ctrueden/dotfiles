test "$DEBUG" && echo "[dotfiles] Loading plugin 'direnv'..."

# Enable direnv if installed.
if which direnv >/dev/null 2>/dev/null
then
  eval "$(direnv hook "$(shell_name)")"
fi
