test "$DEBUG" && echo "[dotfiles] Loading plugin 'init'..."

# Which shell am I running? zsh? bash?
shell_name() {
  local shell=$(ps -o comm= $$)
  echo "${shell#-}"
}
