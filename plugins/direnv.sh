# Enable direnv if installed.
if which direnv >/dev/null 2>/dev/null
then
  eval "$(direnv hook "${SHELL##*/}")"
fi
