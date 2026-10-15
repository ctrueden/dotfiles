# Which shell am I running? zsh? bash?
# Note: zsh and bash identify themselves, since some ps lack -o (e.g. MSYS).
shell_name() {
  if [ -n "${ZSH_VERSION:-}" ]; then echo zsh
  elif [ -n "${BASH_VERSION:-}" ]; then echo bash
  else
    local shell=$(ps -o comm= $$)
    echo "${shell#-}"
  fi
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
