test "$DEBUG" && echo "[dotfiles] Loading plugin 'go'..."

export GOPATH="$HOME/.local/share/go"
path_prepend "$GOPATH/bin"
