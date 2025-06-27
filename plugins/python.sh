test "$DEBUG" && echo "[dotfiles] Loading plugin 'python'..."

pypath() { python -c 'import sys; print("\n".join(sys.path))'; }

# --== pip ==--

pip=$(command -v pip)
test -x "$pip" || pip=$(command -v pip3)
if [ -x "$pip" ]; then
  export PIP="$pip"
else
  # Some pip installations will probably not be on the path yet,
  # so we'll look for them explicitly here to improve our chances.
  for pip in "$MAMBA_DIR/bin/pip"; do
    if [ -x "$(command -v "$pip")" ]; then
      export PIP="$pip"
      break
    fi
  done
fi

# --== uv ==--

# Note: ~/.local/bin is not yet on the PATH; see zzz_path.sh.
case "$(uname)" in
  Darwin) UV=$(printf "$HOME"/Library/Python/*/bin/uv) 2>/dev/null ;;
  Linux) UV="$HOME"/.local/bin/uv ;;
  *) UV= ;;
esac
if [ ! -x "$UV" ]; then
  # Install uv via pip if possible.
  if [ -x "$PIP" ]; then
    "$PIP" install --user uv ||
    "$PIP" install --break-system-packages --user uv
  fi
fi

if [ -x "$UV" ]; then
  # Enable uv shell completion.
  eval "$("$UV" generate-shell-completion $(shell_name))"

  # Add uv convenience shorthands.
  alias uvp='uv run python'
  alias uvi='uv tool install'
  alias uvu='uv tool uninstall'
  alias uvl='uv tool list'
  uve() {
: << 'DOC'
Install the Python project in the current working directory as an editable
tool, replacing any previous installation. As usual with `uv tool install`,
there will be a symlink in `~/.local/bin` pointing to
`~/.local/share/uv/tools/<pkgname>/bin/<exename>`, but in this case, the
tool's source is linked from a local working copy, not downloaded or copied.

Intended as an approximate replacement for `pip install -e . --user`,
although the hotlinked tool is installed into its own isolated environment.
DOC
    test -e pyproject.toml || { >&2 echo '[ERROR] No pyproject.toml.'; return 1; }
    proj=$(grep '^[ \t]*name[ \t]*=' pyproject.toml |
      sed "s/name[ \t]*=[ \t]*[\"']\([^\"']*\).*/\1/")
    test "$proj" || { >&2 echo '[ERROR] Cannot discern project name.'; return 2; }
    uv tool install --reinstall-package "$proj" --with-editable . "$proj"
  }
fi
