#!/bin/sh

# palette.sh - Fuzzy-find a tmux key binding, then press it.
#
# Meant to run inside a tmux popup (see ../byobu/byobu.conf). Rather than
# running the chosen binding directly, it writes a send-keys command into
# tmux's socket directory, as palette-<client-pid>, for the caller to source
# once the popup has closed and the keys can reach the client again.
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

# Lines are: table<TAB>key<TAB>shown-text. The key is escaped for tmux's
# command parser; the shown text is the binding's note (description) if it
# has one, or else its command.
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
        printf "%s%s%s%s%-12s %s\n", table, tab, key, tab, label, desc
      }'
  fi
}
choice=$(
  { bindings prefix; bindings root; } |
  grep -v -E "^root${tab}[^${tab}]*(Mouse|Wheel|Drag|Click)" |
  fzf --reverse --delimiter="$tab" --with-nth=3.. --prompt='tmux> '
) || exit 0

table=$(printf '%s' "$choice" | cut -f1)
key=$(printf '%s' "$choice" | cut -f2)
if [ "$table" = prefix ]; then
  echo "send-keys -K $prefix $key" > "$out"
else
  echo "send-keys -K $key" > "$out"
fi
