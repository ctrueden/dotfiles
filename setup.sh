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
  elif [ -f "$f" ]; then
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

echo
echo "--> Linking up your dotfiles..."

# NB: We use a stub for .bashrc to maintain support for systems that
# do not support proper symlinks -- especially MSysGit on Windows.
BASHRC_STUB="$CONFIG_DIR/bashrc.stub"
echo "export DOTFILES=\"$CONFIG_DIR\"" > "$BASHRC_STUB"
echo '. "$DOTFILES/bashrc"' >> "$BASHRC_STUB"
install_file "$BASHRC_STUB" .bashrc
rm -f "$BASHRC_STUB"

link_file "$LINK_DIR/bash_profile" .bash_profile
link_file "$LINK_DIR/gitconfig" .gitconfig
link_file "$LINK_DIR/jgorc" .jgorc
link_file "$LINK_DIR/mrconfig" .mrconfig
link_file "$LINK_DIR/vimrc" .vimrc
link_file "$LINK_DIR/warprc" .warprc

# Link individual mrconfig.d entries, enabling easier customization.
MRCONFIG_DIR=.mrconfig.d
mkdir -p "$MRCONFIG_DIR"
for mrconfigfile in "$LINK_DIR"/mrconfig.d/*
do
  link_file "$mrconfigfile" "$MRCONFIG_DIR/${mrconfigfile##*/}"
done

# NB: We use a stub for .zshrc to maintain support for systems that
# do not support proper symlinks -- especially MSysGit on Windows.
ZSHRC_STUB="$CONFIG_DIR/zshrc.stub"
echo "export DOTFILES=\"$CONFIG_DIR\"" > "$ZSHRC_STUB"
echo 'source "$DOTFILES/zshrc"' >> "$ZSHRC_STUB"
install_file "$ZSHRC_STUB" .zshrc
rm -f "$ZSHRC_STUB"

case "$(uname)" in
  Darwin)
    cd Library
    link_file "$LINK_DIR/KeyBindings" KeyBindings
    cd ..
    ;;
esac

echo
echo "--> Personalizing your experience..."
cat "$CONFIG_DIR/old-man.txt"
echo "What... is your full name? \c"
read committer_name
echo "What... is your email address? \c"
read committer_email
echo "What... is the airspeed velocity of an unladen --"
echo "The people responsible for this shell script have been sacked."
(set -x; git config --global user.name "$committer_name")
(set -x; git config --global user.email "$committer_email")
(clear_file .forward; set -x; echo "$committer_email" > .forward)
test "$committer_name" = "Curtis Rueden" && link_file "$LINK_DIR/plan" .plan

echo
echo "--> Done! Now open a new terminal. :-)"
