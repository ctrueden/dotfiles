test "$DEBUG" && echo "[dotfiles] Loading zsh plugin 'xterm'..."

# change the title of the current xterm
tt() {
  if [ "$@" ]
  then
    # Disable automatic titles
    DISABLE_AUTO_TITLE="true"
    echo -ne "\e]0;$@\a"
  else
    # Switch back to automatic titles
    unset DISABLE_AUTO_TITLE
  fi
}
