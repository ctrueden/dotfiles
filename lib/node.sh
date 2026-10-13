# Global npm package helpers, shared by install-packages and update-all.

# Prints the bin folder of the Node that owns global npm packages: our own
# (see bin/packages/install-node), or else Homebrew's. Never an nvm-managed
# one, which keeps its globals per Node version. Prints nothing if neither.
global_node_bin() {
  if [ -x "$HOME/.local/bin/node" ]; then
    echo "$HOME/.local/bin"
  elif command -v brew >/dev/null && [ -x "$(brew --prefix)/bin/node" ]; then
    echo "$(brew --prefix)/bin"
  fi
}

# Runs npm from the Node that owns global npm packages.
# Note: npm finds its global prefix relative to the node running it, so that
# node must come first on the PATH, ahead of any nvm-managed one.
global_npm() {
  _bin=$(global_node_bin)
  test -n "$_bin" || { echo "No Node for global npm packages." >&2; return 1; }
  PATH="$_bin:$PATH" npm "$@"
}
