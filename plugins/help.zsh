test "$DEBUG" && echo "[dotfiles] Loading zsh plugin 'help'..."

# Make bash's help command work from zsh. :-P

help() { bash -c "help $@"; }
