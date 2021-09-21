test "$DEBUG" && echo "[dotfiles] Loading plugin 'python'..."

pypath() { python -c 'import sys; print("\n".join(sys.path))'; }
