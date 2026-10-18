# Checksummed downloads, shared by the bin/packages/install-* scripts.

set -u

# Downloads a URL to a temporary file, verified against a SHA-256 or SHA-512
# (told apart by length) recorded by the caller, and stores the file's path in
# $downloaded. The file is removed on exit.
# Note: Call this directly, not as $(download_verified ...), since the EXIT
# trap would then fire as soon as the subshell finished.
download_verified() { # url hash
  case ${#2} in
    64) _sum=sha256sum ;;
    128) _sum=sha512sum ;;
    *) echo "Not a SHA-256 or SHA-512 hash: $2" >&2; return 1 ;;
  esac
  downloaded=$(mktemp) || return 1
  trap 'rm -f "$downloaded"' EXIT
  curl -fsSL "$1" -o "$downloaded" || return 1
  # Note: FreeBSD 13's sha256sum cannot -c from stdin, so compare by hand.
  test "$($_sum "$downloaded" | cut -d' ' -f1)" = "$2" || {
    echo "Checksum mismatch for $1" >&2
    return 1
  }
}
