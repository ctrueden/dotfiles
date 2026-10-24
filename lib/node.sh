# Global npm package helpers, shared by pack and update-all.

# Prints the bin folder of the Node that owns global npm packages: our own
# (see bin/packages/install-node), or else Homebrew's, or else scoop's. Never
# an nvm-managed one, which keeps its globals per Node version. Prints nothing
# if none.
# Note: scoop's Node keeps its globals in scoop's persist folder, so they
# survive its upgrades.
global_node_bin() {
  if [ -x "$HOME/.local/bin/node" ]; then
    echo "$HOME/.local/bin"
  elif command -v brew >/dev/null && [ -x "$(brew --prefix)/bin/node" ]; then
    echo "$(brew --prefix)/bin"
  elif [ -x "${SCOOP:-$HOME/scoop}/apps/nodejs/current/node" ]; then
    echo "${SCOOP:-$HOME/scoop}/apps/nodejs/current"
  fi
}

# Prints an --allow-scripts option naming the npm packages that the manifest
# marks as allowed to run install scripts, if any.
allow_scripts_option() {
  _allowed=$(sed 's/[[:space:]]*|[[:space:]]*/|/g' "${DOTFILES:?}/packages" |
    awk '$2 == "scripts" {
      n = split($1, alt, "|")
      for (i = 1; i <= n; i++) if (alt[i] ~ /^npm:/) print substr(alt[i], 5)
    }' | paste -sd, -)
  test -z "$_allowed" || echo "--allow-scripts=$_allowed"
}

# Runs npm from the Node that owns global npm packages.
# Note: npm finds its global prefix relative to the node running it, so that
# node must come first on the PATH, ahead of any nvm-managed one.
global_npm() {
  _bin=$(global_node_bin)
  test -n "$_bin" || { echo "No Node for global npm packages." >&2; return 1; }
  PATH="$_bin:$PATH" npm "$@"
}
