test "$DEBUG" && echo "[dotfiles] Loading bash plugin 'xterm'..."

# change the title of the current xterm
tt() {
  TERM_TITLE="$@"
}
