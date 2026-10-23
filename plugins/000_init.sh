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

# Succeeds if the given command is available (executable, function, alias or builtin).
has() { command -v "$1" >/dev/null; }

# Path interrogation functions; lib/path.sh has the manipulation ones.
spath() { echo "$1" | sed -e 's/:/\n/g'; }
path() { spath "$PATH"; }
