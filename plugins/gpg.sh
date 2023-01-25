test "$DEBUG" && echo "[dotfiles] Loading plugin 'gpg'..."

# Oh GPG, you're so quirky!

test "$GPG_TTY" || export GPG_TTY=$(tty)
