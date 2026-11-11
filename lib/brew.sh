# Homebrew helper, shared by the shell plugins, pack and update-all.

# Prints the user who owns the Homebrew installation at $BREW.
# Note: On Intel macOS, $BREW is /usr/local, which root owns; the Homebrew
# repository inside it is what the installing user owns.
brew_owner() {
  _brew_dir=$BREW/Homebrew
  test -d "$_brew_dir" || _brew_dir=$BREW
  ls -ld "$_brew_dir" | awk '{print $3}'
}

# Runs brew as whoever owns the Homebrew installation.
# Note: macOS's sudo keeps HOME, so plain sudo -u leaves brew writing its
# cache and logs into our home, which it cannot do. Hence the env HOME=...
brew() {
  _brew_owner=$(brew_owner)
  if [ -z "$_brew_owner" ] || [ "$_brew_owner" = "$(id -un)" ]; then
    command brew "$@"
  else
    _brew_home=$(eval echo "~$_brew_owner")
    sudo -u "$_brew_owner" env HOME="$_brew_home" "$BREW/bin/brew" "$@"
  fi
}
