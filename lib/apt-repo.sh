# Third-party apt repositories, shared by the bin/packages/install-* scripts.

set -u

SUDO=sudo
test "$(id -u)" -eq 0 && SUDO=

# Fails unless apt is here to use a repository.
# Note: A Linux machine with brew but no apt may still pick a custom installer.
apt_repo_require() {
  command -v apt-get >/dev/null && return
  echo "${0##*/}: needs apt, which this machine lacks." >&2
  return 1
}

# Succeeds if the named package is installed.
apt_installed() { # package
  dpkg-query -W -f='${db:Status-Abbrev}' "$1" 2>/dev/null | grep -q '^ii'
}

# Succeeds if an active sources entry, in either format, names the given URL.
# Note: Some packages, such as 1Password's, rewrite their own entries.
apt_repo_has() { # url
  grep -qs "^[^#]*$1" /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources
}

# Installs the signing key at a URL as the given keyring, unless it is already
# there, after checking that the key carries each of the given fingerprints.
# A keyring named *.gpg gets the key in binary form, as older apt requires.
apt_repo_key() { # url keyring fingerprint...
  _url=$1 _keyring=$2; shift 2
  test -e "$_keyring" && return
  _key=$(mktemp) || return 1
  curl -fsSL -o "$_key" "$_url" || { rm -f "$_key"; return 1; }
  for _fp in "$@"; do
    gpg --show-keys --with-colons "$_key" 2>/dev/null |
      grep -q "^fpr:*$_fp:" || {
        echo "Key from $_url lacks fingerprint $_fp" >&2
        rm -f "$_key"
        return 1
      }
  done
  case "$_keyring" in
    *.gpg)
      if grep -q 'BEGIN PGP' "$_key"; then
        gpg --dearmor < "$_key" > "$_key.gpg" && mv "$_key.gpg" "$_key" ||
          { rm -f "$_key" "$_key.gpg"; return 1; }
      fi ;;
  esac
  $SUDO mkdir -p -m 755 "${_keyring%/*}" &&
    $SUDO tee "$_keyring" < "$_key" >/dev/null &&
    $SUDO chmod go+r "$_keyring"
  _status=$?
  rm -f "$_key"
  return $_status
}

# Writes a root-owned apt configuration file, such as a sources list or a pin.
apt_repo_file() { # path content
  $SUDO mkdir -p -m 755 "${1%/*}" &&
    printf '%s\n' "$2" | $SUDO tee "$1" >/dev/null
}

# Writes /etc/apt/sources.list.d/NAME.sources, in apt's deb822 format,
# for a repository signed by the given keyring.
apt_repo_sources() { # name uri suites components keyring [architectures]
  apt_repo_file "/etc/apt/sources.list.d/$1.sources" "Types: deb
URIs: $2
Suites: $3
Components: $4
${6:+Architectures: $6
}Signed-By: $5"
}
