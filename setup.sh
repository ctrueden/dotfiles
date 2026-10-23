#!/bin/sh

set -e

# -- Global variables --

CONFIG_DIR=$(cd "$(dirname $0)"; pwd)
# NB: Git Bash's pwd gives C:/... or /c/..., depending on how bash started;
# settle on one, so the stubs written below stay the same from run to run.
! command -v cygpath >/dev/null || CONFIG_DIR=$(cygpath -u "$CONFIG_DIR")
# Note: Tool installers invoked below (e.g. bin/packages/install-*) need this,
# and on a fresh machine no shell has exported it yet.
export DOTFILES="$CONFIG_DIR"
cd

. "$CONFIG_DIR/lib/files.sh"

# -- Main --

# NB: On Windows, setup.ps1 is the entry point, which runs this script and
# then sets up PowerShell and Windows Terminal. Run directly, defer to it.
if [ -n "$WINDOWS" ] && [ -z "${DOTFILES_SETUP_PS1:-}" ]; then
  exec powershell -NoProfile -ExecutionPolicy Bypass \
    -File "$(cygpath -w "$CONFIG_DIR/setup.ps1")"
fi

echo
echo "--> Linking up your dotfiles..."

# NB: We use stub files for some shell config files, to maintain support for
# systems that do not support proper symlinks -- especially MSysGit on Windows.
# It also enables command-line tools such as conda to mess with these
# files as they desire without dirtying the dotfiles working copy.

# ~/.bashrc
for cfgFile in bashrc bash_profile zshrc
do
  # Skip if the file already sources the dotfiles -- it may have tool-managed
  # blocks appended (conda init, nvm, etc.) that we must not clobber.
  grep -qF '$DOTFILES' ".$cfgFile" 2>/dev/null && continue
  tmpFile="$CONFIG_DIR/$cfgFile.stub"
  rm -f "$tmpFile"
  if [ "$cfgFile" = "bashrc" ]; then
    # Bash interactive guard: prevent non-interactive sessions (e.g., gdm3 login)
    # from sourcing bashrc, which would leak exports into the X session environment.
    echo '[ -z "$PS1" ] && return # Continue only if shell is interactive.' >> "$tmpFile"
  fi
  echo "export DOTFILES=\"$CONFIG_DIR\"" >> "$tmpFile"
  echo ". \"\$DOTFILES/$cfgFile\"" >> "$tmpFile"
  install_file "$tmpFile" ".$cfgFile"
  rm -f "$tmpFile"
done

# ~/.gitconfig
# NB: We use a stub for .gitconfig so that it can be extended with a
# [user] section without causing git to see the gitconfig here as dirty.
# Skip if it already exists -- it likely has a [user] section appended.
if [ ! -f .gitconfig ]; then
  GITCONFIG_STUB="$CONFIG_DIR/gitconfig.stub"
  echo '[include]' > "$GITCONFIG_STUB"
  printf "\tpath = $CONFIG_DIR/gitconfig\n" >> "$GITCONFIG_STUB"
  install_file "$GITCONFIG_STUB" .gitconfig
  rm -f "$GITCONFIG_STUB"
fi

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

mkdir -p .config

# ~/.config/starship.toml
# NB: The shells set STARSHIP_CONFIG to the dotfiles' copy instead.
unlink_file .config/starship.toml

# ~/.config/jgo.conf
# NB: The shells set JGO_CONFIG_FILE to the dotfiles' copy instead.
unlink_file .config/jgo.conf

# ~/.config/byobu/.tmux.conf [not Windows, which lacks byobu]
# NB: We stub or link only these files, not the whole directory, because
# byobu writes its own state and settings into ~/.config/byobu.
# On Windows, setup.ps1 writes a similar stub for psmux instead.
if [ -z "$WINDOWS" ]; then
  mkdir -p .config/byobu
  stub_file .config/byobu/.tmux.conf \
    "source-file \"$CONFIG_DIR/tmux/tmux.conf\"" \
    "source-file \"$CONFIG_DIR/byobu/byobu.conf\""
  # Note: tmux.conf and byobu.conf find these in the dotfiles directly.
  unlink_file .config/byobu/palette.sh
  unlink_file .config/byobu/notes.tmux
  unlink_file .config/byobu/fkeys-toggle.tmux
  link_file "$CONFIG_DIR/byobu/status" .config/byobu/status
  link_file "$CONFIG_DIR/byobu/statusrc" .config/byobu/statusrc
  mkdir -p .config/byobu/bin
  for f in "$CONFIG_DIR"/byobu/bin/*; do
    link_file "$f" ".config/byobu/bin/$(basename "$f")"
  done
fi

# ~/.tmux.conf [not Windows, where setup.ps1 writes ~/.psmux.conf instead]
# NB: Byobu reads its own config above, so this is for plain tmux,
# as zshrc launches over SSH where byobu is missing.
if [ -z "$WINDOWS" ]; then
  stub_file .tmux.conf \
    "source-file \"$CONFIG_DIR/tmux/tmux.conf\"" \
    "source-file \"$CONFIG_DIR/tmux/fkeys.conf\"" \
    'bind-key -N "Reload the tmux configuration" -n F5 source-file ~/.tmux.conf'
fi

# ~/.mrconfig
# NB: A stub lets `mr register` add to it without dirtying the dotfiles.
stub_file .mrconfig "include = cat \"$CONFIG_DIR/mrconfig\""

# ~/.config/mr
mkdir -p .config/mr
stub_file .config/mr/essential "include = cat \"$CONFIG_DIR/mrconfig.d/essential\""

# ~/.vim/vimrc
mkdir -p .vim
stub_file .vim/vimrc "source $CONFIG_DIR/vimrc"

# ~/.config/kitty [not Windows, which kitty does not support]
# NB: A stub lets `kitten themes` edit kitty.conf without dirtying the dotfiles.
if [ -z "$WINDOWS" ]; then
  mkdir -p .config/kitty
  stub_file .config/kitty/kitty.conf "include $CONFIG_DIR/kitty/kitty.conf"
  link_file "$CONFIG_DIR/kitty/quick-access-terminal.conf" \
    .config/kitty/quick-access-terminal.conf
fi

# ~/.XCompose [not Windows, which lacks X]
test -n "$WINDOWS" || link_file "$CONFIG_DIR/XCompose" .XCompose

# ~/Library/KeyBindings [macOS]
case "$(uname)" in
  Darwin)
    cd Library
    link_file "$CONFIG_DIR/KeyBindings" KeyBindings
    cd ..
    ;;
esac

# Calculate questions we need to ask.
_questions=0

# Check for existing recorded git identity.
# Note: We ask whenever the identity is unset, rather than when .gitconfig
# is absent, since the stub written above has already created .gitconfig.
_q_name=
if [ -t 0 ] && [ -z "$(git config --global user.name)" ]; then
  _q_name=1; _questions=$((_questions=1))
fi
_q_email=
if [ -t 0 ] && [ -z "$(git config --global user.email)" ]; then
  _q_email=1; _questions=$((_questions=1))
fi

# Check for existing recorded package section preferences.
_q_quest=
profile="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/sections"
if [ -t 0 ] && [ ! -f "$profile" ]; then
  _q_quest=1; _questions=$((_questions+1))
fi

# Prompt the user if there are any questions to answer.
if [ "$_questions" -gt 0 ]; then
  echo
  echo "--> Personalizing your experience..."

  _questions=$((_questions+1))  # Always ask about the swallow.
  case "$_questions" in
    1) _q_count="this question one";      _q_verb="not shun";;
    2) _q_count="these questions two";    _q_verb="run to";;
    3) _q_count="these questions three";  _q_verb="see";;
    4) _q_count="these questions four";   _q_verb="explore";;
    *) _q_count="these questions galore"; _q_verb="explore";;
  esac

  cat "$CONFIG_DIR/old-man.txt"
  echo "Answer me $_q_count, ere the other side ye $_q_verb!"

  if [ "$_q_name" ]; then
    printf "What... is your full name? "
    read committer_name
    (set -x; git config --global user.name "$committer_name")
    test "$committer_name" = "Curtis Rueden" && link_file "$CONFIG_DIR/plan" .plan
  fi

  # Which opt-in sections of the packages manifest this machine wants.
  # Asked once, then remembered; edit the file to change it.
  if [ "$_q_quest" ]; then
    echo "What... is your quest?"
    sed -n "s/^#   \([a-z]*  \)/  \1/p" "$CONFIG_DIR/packages"
    printf "Opt-in package sections, space-separated [none]: "
    read quest
    mkdir -p "$(dirname "$profile")"
    printf "%s\n" $quest > "$profile"
  fi

  if [ "$_q_email" ]; then
    printf "What... is your email address? "
    read committer_email
    (set -x; git config --global user.email "$committer_email")
    (clear_file .forward; set -x; echo "$committer_email" > .forward)
  fi

  echo "What... is the airspeed velocity of an unladen --"
  echo "The people responsible for this shell script have been sacked."
fi

echo
echo "--> Installing tools..."

# Packages from the manifest (neovim, starship, byobu, fzf, AI TUIs, etc.).
# Note: The rest of setup does not depend on these, so a failure is not fatal.
"$CONFIG_DIR/bin/system/pack" install ||
  echo "Warning: package installation failed; continuing setup." >&2

echo
echo "--> Configuring tools..."

for _s in "$CONFIG_DIR/setup"/*; do
  test -x "$_s" || continue
  "$_s"
done


echo
echo "--> Done! Now open a new terminal. :-)"
