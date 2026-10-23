# PATH assembly, shared by every shell: the ~/.zshenv stub sources this for
# each zsh (scripts and zsh -c included), and zshrc, bashrc and bash_profile
# source it too, so that commands run outside an interactive shell (e.g. tmux
# popups and byobu status widgets) find the same tools.
#
# Sourcing it again is harmless, and moves these dirs back to the front: on
# macOS, /etc/zprofile's path_helper puts the system dirs first for login
# shells, after ~/.zshenv runs; and plugins prepend dirs of their own, which
# plugins/zzz_path.sh puts behind these.
#
# Note: zsh reads ~/.zshenv for every shell, so this must stay fast, e.g. by
# finding Homebrew without running the slow brew --prefix.

# Path manipulation functions.
path_filter() {
  filtered=$(
    echo "$@" | tr ':' '\n' | while read p; do
      test ! -d "$p" ||    # Does the directory exist?
      echo "$p"            # Include it!
    done |
      awk '!seen[$0]++' |  # Remove duplicate entries
      tr '\n' ':'          # Join lines with colon separator
  )
  echo "${filtered%:}"     # Remove trailing colon
}
path_prepend() {
  export PATH_PREPEND="$1:$PATH_PREPEND"
}
path_append() {
  export PATH_APPEND="$PATH_APPEND:$1"
}
path_update() {
  export PATH=$(path_filter "$PATH_PREPEND:$PATH:$PATH_APPEND")
  unset PATH_PREPEND
  unset PATH_APPEND
}

if [ -z "$BREW" ]; then
  for _d in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
    test -x "$_d/bin/brew" && export BREW="$_d" && break
  done
fi

path_prepend "$HOME/.local/bin"                 # pip --user, uv (Linux)
_d=$(echo "$HOME"/Library/Python/*/bin | head -n1) 2>/dev/null
path_prepend "$_d"                              # pip --user (macOS)

# Dotfiles scripts, with those for other OSes left out.
_os=$(uname)
for _d in "${DOTFILES:?}"/bin/*; do
  [ -d "$_d" ] || continue
  case "${_d##*/}" in
    linux) [ "$_os" != Linux ] || path_prepend "$_d" ;;
    macos) [ "$_os" != Darwin ] || path_prepend "$_d" ;;
    windows) case "$_os" in CYGWIN*|MINGW*|MSYS*) path_prepend "$_d" ;; esac ;;
    *) path_prepend "$_d" ;;
  esac
done
path_prepend "$DOTFILES/bin"

if [ -d "$BREW" ]; then
  for _d in bin sbin opt/ruby/bin opt/util-linux/bin opt/util-linux/sbin; do
    path_prepend "$BREW/$_d"
  done
fi

path_prepend /snap/bin
path_prepend /usr/local/bin
path_prepend "$HOME/bin"     # Let personal bin scripts override others.

path_update
unset _d _os
