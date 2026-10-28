# File management helpers (stubs, symlinks, backups), shared by setup scripts.

STAMP=${STAMP:-$(date +%Y%m%dT%H%M%S)}

case "$(uname)" in
  MINGW*|MSYS*|CYGWIN*) WINDOWS=1 ;;
  *) WINDOWS= ;;
esac

# Clears away the given file, backing it up first if needed.
# If it is a real file (not a symlink), it is renamed.
# Or if the file is a symlink, it is simply deleted.
clear_file() {
  f="$1"
  if [ -h "$f" ]; then
    (set -x; rm "$f")
  elif [ -f "$f" ]; then
    bk="$f.$STAMP"
    (set -x; mv "$f" "$bk")
  fi
}

# Copies the given source to the specified destination.
# Does nothing if files match; otherwise, replaces the original file.
install_file() {
  src="$1"
  dest="$2"
  diff "$src" "$dest" > /dev/null 2>&1 ||
    (clear_file "$dest"; set -x; cp "$src" "$dest")
}

# Symlinks the given source to the specified destination.
# Does nothing if the destination already links there.
# Note: Windows restricts creating symlinks, so there it copies the file
# instead. A hard link would be no better: it detaches silently whenever git
# replaces the file in the working copy.
link_file() {
  src="$1"
  dest="$2"
  if [ -n "$WINDOWS" ]; then
    install_file "$src" "$dest"
    return
  fi
  test -h "$dest" && test "$(readlink "$dest")" = "$src" && return
  clear_file "$dest"
  (set -x; ln -sf "$src" "$dest")
}

# Writes a stub to the given destination, whose lines are the remaining
# arguments, replacing what is there unless it already matches.
stub_file() {
  stub_dest="$1"; shift
  stub=$(mktemp)
  printf '%s\n' "$@" > "$stub"
  install_file "$stub" "$stub_dest"
  rm -f "$stub"
}

# Removes a link (on Windows, a copy) that this script once made,
# which a stub or setting now replaces.
unlink_file() {
  if [ -h "$1" ] || { [ -n "$WINDOWS" ] && [ -f "$1" ]; }; then
    (set -x; rm "$1")
  fi
}
