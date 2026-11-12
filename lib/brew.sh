# Homebrew helper, shared by the shell plugins, pack and update-all.

# Prints the user who owns the Homebrew installation at $BREW.
# Note: On Intel macOS, $BREW is /usr/local, which root owns; the Homebrew
# repository inside it is what the installing user owns.
brew_owner() {
  _brew_dir=$BREW/Homebrew
  test -d "$_brew_dir" || _brew_dir=$BREW
  ls -ld "$_brew_dir" | awk '{print $3}'
}

# Runs brew as whoever owns the Homebrew installation, as brew as-brew-user
# does, which cannot help here: it refuses a root-owned prefix like /usr/local.
# Note: macOS's sudo keeps HOME, so plain sudo -u leaves brew writing its
# cache into our home, which it cannot do. Hence the clean environment.
# HOMEBREW_SUDO_THROUGH_SUDO_USER routes casks' sudo calls back through us,
# so they ask for our password rather than the owner's. That needs sudoers to
# let the owner run sudo as us, keeping the environment (brew uses sudo -E):
#   them ALL=(you) NOPASSWD:SETENV: /usr/bin/sudo
# where `them` is the Homebrew owner, and `you` is your username.
brew() {
  _brew_owner=$(brew_owner)
  if [ -z "$_brew_owner" ] || [ "$_brew_owner" = "$(id -un)" ]; then
    command brew "$@"
  else
    sudo -H -u "$_brew_owner" /usr/bin/env -i \
      HOME="$(eval echo "~$_brew_owner")" \
      USER="$_brew_owner" \
      LOGNAME="$_brew_owner" \
      PATH=/usr/bin:/bin:/usr/sbin:/sbin \
      SUDO_USER="$(id -un)" \
      HOMEBREW_SUDO_THROUGH_SUDO_USER=1 \
      "$BREW/bin/brew" "$@"
  fi
}
