#!/bin/sh

set -e

# -- Global variables --

CONFIG_DIR=$(cd "$(dirname $0)"; pwd)
cd

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

# ~/.bashrc
# NB: We use a stub for .bashrc to maintain support for systems that
# do not support proper symlinks -- especially MSysGit on Windows.
BASHRC_STUB="$CONFIG_DIR/bashrc.stub"
echo "export DOTFILES=\"$CONFIG_DIR\"" > "$BASHRC_STUB"
echo '. "$DOTFILES/bashrc"' >> "$BASHRC_STUB"
install_file "$BASHRC_STUB" .bashrc
rm -f "$BASHRC_STUB"

# ~/.zshrc
# NB: We use a stub for .zshrc to maintain support for systems that
# do not support proper symlinks -- especially MSysGit on Windows.
ZSHRC_STUB="$CONFIG_DIR/zshrc.stub"
echo "export DOTFILES=\"$CONFIG_DIR\"" > "$ZSHRC_STUB"
echo 'source "$DOTFILES/zshrc"' >> "$ZSHRC_STUB"
install_file "$ZSHRC_STUB" .zshrc
rm -f "$ZSHRC_STUB"

# ~/.gitconfig
# NB: We use a stub for .gitconfig so that it can be extended with a
# [user] section without causing git to see the gitconfig here as dirty.
GITCONFIG_STUB="$CONFIG_DIR/gitconfig.stub"
echo '[include]' > "$GITCONFIG_STUB"
printf "\tpath = $CONFIG_DIR/gitconfig\n" >> "$GITCONFIG_STUB"
install_file "$GITCONFIG_STUB" .gitconfig
rm -f "$GITCONFIG_STUB"

# ~/.ssh/config
# NB: We write out a starter .ssh/config so that it can be extended with
# additional configuration without causing git to see the file as dirty.
SSHCONFIG=.ssh/config
if [ ! -f "$SSHCONFIG" ]
then
  mkdir -p .ssh
  for f in "$CONFIG_DIR/ssh.d"/*
  do
    (set -x; echo "Include $f" >> "$SSHCONFIG")
  done
fi

# ~/.bash_profile
link_file "$CONFIG_DIR/bash_profile" .bash_profile

# ~/.jgorc
link_file "$CONFIG_DIR/jgorc" .jgorc

# ~/.mrconfig
link_file "$CONFIG_DIR/mrconfig" .mrconfig

# ~/.config/mr
mkdir -p .config/mr
link_file "$CONFIG_DIR/mrconfig.d/essential" .config/mr/essential

# ~/.config/wd
mkdir -p .config/wd
link_file "$CONFIG_DIR/warprc" .config/wd/warprc

# ~/.vim/vimrc
mkdir -p .vim
link_file "$CONFIG_DIR/vimrc" .vim/vimrc

# ~/.XCompose
link_file "$CONFIG_DIR/XCompose" .XCompose

# ~/bin
# NB: It's OK if the sources don't exist yet, or ever.
# This step just makes them available on the path,
# in case they do get cloned locally into ~/code.
mkdir -p bin
link_file "../code/git/git-diff-blame/git-diff-blame" bin/git-diff-blame
link_file "../code/git/git-recover/git-recover" bin/git-recover
link_file "../code/scijava/jgo/jgo.sh" bin/jgo
link_file "../code/util/icat/icat" bin/icat

# ~/Library/KeyBindings [macOS]
case "$(uname)" in
  Darwin)
    cd Library
    link_file "$CONFIG_DIR/KeyBindings" KeyBindings
    cd ..
    ;;
esac

echo
echo "--> Personalizing your experience..."
cat "$CONFIG_DIR/old-man.txt"
echo "Answer me these questions three, ere the other side ye see!"
printf "What... is your full name? "
read committer_name
printf "What... is your email address? "
read committer_email
echo "What... is the airspeed velocity of an unladen --"
echo "The people responsible for this shell script have been sacked."
(set -x; git config --global user.name "$committer_name")
(set -x; git config --global user.email "$committer_email")
(clear_file .forward; set -x; echo "$committer_email" > .forward)

# ~/.plan
test "$committer_name" = "Curtis Rueden" && link_file "$CONFIG_DIR/plan" .plan

echo
echo "--> Done! Now open a new terminal. :-)"
