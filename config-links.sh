#!/bin/sh

set -e

# -- Global variables --

CONFIG_DIR=$(cd "$(dirname $0)"; pwd)
cd
USER_DIR=$(pwd)
LINK_DIR=${CONFIG_DIR#$USER_DIR/}

OS_NAME=$(uname)
STAMP=$(date +%Y%m%dT%H%M%S)

# -- Functions --

# Clears away the given file, backing it up first if needed.
# If it is a real file (not a symlink), it is renamed.
# Or if the file is a symlink, it is simply deleted.
clear_file() {
  f="$1"
  if [ -h "$f" ]; then
    (set -x; rm "$f")
  fi
  if [ -a "$f" ]; then
    bk="$f.$STAMP"
    (set -x; mv "$f" "$bk")
  fi
}

# Copies the given source to the specified destination.
# Does nothing if files match; otherwise, replaces the original file.
install_file() {
  src="$1"
  dest="$2"
  diff "$src" "$dest" > /dev/null 2>&1 ||
    (clear_file "$dest"; set -x; cp "$src" "$dest")
}

# Symlinks the given source to the specified destination.
link_file() {
  src="$1"
  dest="$2"
  clear_file "$dest"
  (set -x; ln -s "$src" "$dest")
}

# -- Main --

echo "export DOTFILES=\"$CONFIG_DIR\"" > "$TMPDIR/bashrc.stub"
echo '. "$DOTFILES/bashrc"' >> "$TMPDIR/bashrc.stub"
install_file "$TMPDIR/bashrc.stub" .bashrc
link_file "$LINK_DIR/forward" .forward
link_file "$LINK_DIR/gitconfig" .gitconfig
link_file "$LINK_DIR/mrconfig" .mrconfig
link_file "$LINK_DIR/plan" .plan
link_file "$LINK_DIR/vimrc" .vimrc
echo "export DOTFILES=\"$CONFIG_DIR\"" > "$TMPDIR/zshrc.stub"
echo 'source "$DOTFILES/zshrc"' >> "$TMPDIR/zshrc.stub"
install_file "$TMPDIR/zshrc.stub" .zshrc

case "$(uname)" in
  Darwin)
    cd Library
    link_file "../$LINK_DIR/KeyBindings" KeyBindings
    cd ..
    ;;
esac
