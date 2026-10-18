#!/bin/sh

# palette.sh - Fuzzy-find a tmux key binding, then press it.
#
# Meant to run inside a tmux popup (see tmux.conf). Rather than running the
# chosen binding directly, it writes a send-keys command into tmux's socket
# directory, as palette-<client-pid>, for the caller to source once the popup
# has closed and the keys can reach the client again.

command -v fzf >/dev/null 2>&1 || {
  echo "palette.sh: fzf is not installed."
  sleep 3
  exit 1
}

out="$(dirname "${TMUX%%,*}")/palette-$(tmux display -p '#{client_pid}')"
rm -f "$out"

prefix=$(tmux show -gv prefix)

# Lines are: table<TAB>key<TAB>shown-text, plus <TAB>command for tmux before
# 3.5 (see below). The key is escaped for tmux's command parser; the shown
# text is the binding's note (description) if it has one, or else its command.
tab=$(printf '\t')
bindings() {
  if tmux list-keys -T "$1" -F x >/dev/null 2>&1; then
    label="#{?#{==:#{key_table},prefix},$prefix ,}#{key_string}"
    desc='#{=/100/...:#{?key_note,#{key_note},#{key_command}}}'
    tmux list-keys -T "$1" -F "#{key_table}$tab#{q:key_string}$tab#{p12:$label} $desc"
  else
    # Note: tmux before 3.5 lacks list-keys -F, so parse the default listing
    # (bind-key [-r] -T table key command), which escapes the key, and the
    # notes listing (key note), which does not.
    { tmux list-keys -N -P '' -T "$1"; echo; tmux list-keys -T "$1"; } |
    awk -v table="$1" -v prefix="$prefix" -v tab="$tab" '
      !plain && /^$/ { plain = 1; next }
      !plain {
        sub(/^ +/, ""); key = $1; sub(/^[^ ]+ +/, ""); note[key] = $0; next
      }
      {
        line = $0
        sub(/^bind-key +(-r +)?-T +[^ ]+ +/, "", line)
        key = line; sub(/ .*/, "", key)
        cmd = line; sub(/^[^ ]+ +/, "", cmd)
        bare = key
        if (bare ~ /^\\./) bare = substr(bare, 2)
        else if (bare ~ /^\047.*\047$/ || bare ~ /^".*"$/) bare = substr(bare, 2, length(bare) - 2)
        desc = (bare in note) ? note[bare] : cmd
        if (length(desc) > 100) desc = substr(desc, 1, 100) "..."
        label = (table == "prefix" ? prefix " " : "") bare
        printf "%s%s%s%s%-12s %s%s%s\n", table, tab, key, tab, label, desc, tab, cmd
      }'
  fi
}
choice=$(
  { bindings prefix; bindings root; } |
  grep -v -E "^root${tab}[^${tab}]*(Mouse|Wheel|Drag|Click)" |
  fzf --reverse --delimiter="$tab" --with-nth=3 --prompt='tmux> '
) || exit 0

# Note: send-keys -K, which presses a key as the client would, needs tmux 3.4;
# before that, run the binding's command instead.
version=$(tmux -V | sed 's/^[^0-9]*//; s/[^0-9.].*//')
case "$version" in
  [0-2].*|3.[0-3]) printf '%s\n' "$choice" | cut -f4- > "$out"; exit ;;
esac

table=$(printf '%s' "$choice" | cut -f1)
key=$(printf '%s' "$choice" | cut -f2)
if [ "$table" = prefix ]; then
  echo "send-keys -K $prefix $key" > "$out"
else
  echo "send-keys -K $key" > "$out"
fi
