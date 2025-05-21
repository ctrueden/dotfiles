test "$DEBUG" && echo "[dotfiles] Loading plugin 'init'..."

# Which shell am I running? zsh? bash?
shell_name() {
  local shell=$(ps -o comm= $$)
  echo "${shell#-}"
}

# Path interrogation and manipulation functions.
spath() { echo "$1" | sed -e 's/:/\n/g'; }
path() { spath "$PATH"; }
path_filter() {
  filtered=$(
    echo "$@" | tr ':' '\n' | while read p; do
      test ! -d "$p" ||    # Does the directory exist?
      echo "$p"            # Include it!
    done |
      awk '!seen[$0]++' |  # Remove duplicate entries
      tr '\n' ':'          # Join lines with colon separator
  )
  echo "${filtered%:}"     # Remove trailing colon
}
path_prepend() {
  export PATH_PREPEND="$1:$PATH_PREPEND"
}
path_append() {
  export PATH_APPEND="$PATH_APPEND:$1"
}
path_update() {
  export PATH=$(path_filter "$PATH_PREPEND:$PATH:$PATH_APPEND")
  unset PATH_PREPEND
  unset PATH_APPEND
}
