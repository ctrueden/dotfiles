# Shared helpers for the install-* scripts; source, don't execute.

set -u

# Downloads a URL to a temporary file, verified against a SHA-256 recorded by
# the caller, and stores the file's path in $downloaded. The file is removed
# on exit.
# Note: Call this directly, not as $(download_verified ...), since the EXIT
# trap would then fire as soon as the subshell finished.
download_verified() { # url sha256
  downloaded=$(mktemp) || return 1
  trap 'rm -f "$downloaded"' EXIT
  curl -fsSL "$1" -o "$downloaded" || return 1
  echo "$2  $downloaded" | sha256sum -c - >/dev/null || {
    echo "Checksum mismatch for $1" >&2
    return 1
  }
}
