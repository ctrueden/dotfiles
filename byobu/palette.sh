#!/bin/sh

# palette.sh - Fuzzy-find a tmux key binding, then press it.
#
# Meant to run inside a tmux popup (see tmux.conf). Rather than running the
# chosen binding directly, it writes a send-keys command into tmux's socket
# directory, as palette-<client-pid>, for the caller to source once the popup
# has closed and the keys can reach the client again.
#
# Example binding for ~/.byobu/.tmux.conf:
#
#   bind-key Space display-popup -E -w 80% -h 60% \
#   '~/.config/byobu/palette.sh' \; \
#   source-file -qF '#{d:socket_path}/palette-#{client_pid}'

command -v fzf >/dev/null 2>&1 || {
  echo "palette.sh: fzf is not installed."
  sleep 3
  exit 1
}

out="$(dirname "${TMUX%%,*}")/palette-$(tmux display -p '#{client_pid}')"
rm -f "$out"

prefix=$(tmux show -gv prefix)

# Lines are: table<TAB>key<TAB>shown-text. The shown text is the binding's
# note (description) if it has one, or else its command.
choice=$(
  {
    tmux list-keys -N -T prefix | sed 's/^/N /'
    tmux list-keys -T prefix
    tmux list-keys -T root
  } | awk -v prefix="$prefix" '
    $1 == "N" { k = $2; sub(/^N +[^ ]+ +/, ""); note[k] = $0; next }
    {
      i = ($2 == "-r") ? 4 : 3
      table = $i; key = $(i + 1)
      if (key ~ /Mouse|Wheel|Drag/) next
      cmd = $0; sub("^bind-key +(-r +)?-T +[^ ]+ +[^ ]+ +", "", cmd)
      label = (table == "prefix") ? prefix " " key : key
      desc = (key in note && table == "prefix") ? note[key] : cmd
      if (length(desc) > 100) desc = substr(desc, 1, 97) "..."
      printf "%s\t%s\t%-12s %s\n", table, key, label, desc
    }' |
  fzf --reverse --delimiter='\t' --with-nth=3.. --prompt='tmux> '
) || exit 0

table=$(printf '%s' "$choice" | cut -f1)
key=$(printf '%s' "$choice" | cut -f2)
if [ "$table" = prefix ]; then
  echo "send-keys -K $prefix $key" > "$out"
else
  echo "send-keys -K $key" > "$out"
fi
