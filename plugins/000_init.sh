test "$DEBUG" && echo "[dotfiles] Loading plugin 'init'..."

# Which shell am I running? zsh? bash?
shell_name() {
  local shell=$(ps -o comm= $$)
  echo "${shell#-}"
}

spath() { echo "$1" | sed -e 's/:/\n/g'; }
path() { spath "$PATH"; }
path_prepend() {
  test -d "$1" || return
  path | grep -Fxq "$1" && return
  test "$PATH_PREPEND" &&
    export PATH_PREPEND="$PATH_PREPEND:$1" ||
    export PATH_PREPEND="$1"
}
path_append() {
  test -d "$1" || return
  path | grep -Fxq "$1" && return
  test "$PATH_APPEND" &&
    export PATH_APPEND="$PATH_APPEND:$1" ||
    export PATH_APPEND="$1"
}
path_update() {
  test "$PATH_PREPEND" && export PATH="$PATH_PREPEND:$PATH"
  unset PATH_PREPEND
  test "$PATH_APPEND" && export PATH="$PATH:$PATH_APPEND"
  unset PATH_APPEND
}
