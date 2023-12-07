test "$DEBUG" && echo "[dotfiles] Loading plugin 'rust'..."

# If cargo is installed, add its bin directory to the system path.
if [ -d "$CARGO_HOME" ]
then
  path_prepend "$CARGO_HOME/bin"
elif [ -d "$HOME/.cargo" ]
then
  path_prepend "$HOME/.cargo/bin"
fi
