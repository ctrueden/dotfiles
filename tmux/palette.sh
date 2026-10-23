#!/bin/sh

# palette.sh - Fuzzy-find a tmux key binding, then press it.
#
# Meant to run inside a tmux popup (see tmux.conf). Rather than running the
# chosen binding directly, it writes a send-keys command into tmux's socket
# directory, as palette-<client-pid>, for the caller to source once the popup
# has closed and the keys can reach the client again. With --run, for psmux
# (see psmux.conf), it runs the chosen binding's command itself instead,
# once the popup has closed.

# palette.sh --exec FILE: run the tmux command in FILE, as --run arranges.
# Note: The pause lets the popup close first, so that the command can use the
# client (e.g. command-prompt, for renaming).
if [ "$1" = --exec ]; then
  sleep 0.5
  eval "tmux $(cat "$2")"
  exit
fi

command -v fzf >/dev/null || {
  echo "palette.sh: fzf is not installed."
  sleep 3
  exit 1
}

run=
[ "$1" = --run ] && run=1

out=$(tmux display -p '#{d:socket_path}/palette-#{client_pid}')
rm -f "$out"

# Note: The session's prefix, which the client-attached hook in tmux.conf sets,
# can differ from the global one.
prefix=$(tmux display -p '#{prefix}')

# Lines are: table<TAB>key<TAB>shown-text<TAB>command. The key is escaped for
# tmux's command parser; the shown text is the binding's note (description) if
# it has one, or else its command.
tab=$(printf '\t')
bindings() {
  # Note: psmux ignores list-keys -F, printing its default listing instead,
  # so check the output, not just the exit status.
  if [ "$(tmux list-keys -T "$1" -F x 2>/dev/null | head -n 1)" = x ]; then
    label="#{?#{==:#{key_table},prefix},$prefix ,}#{key_string}"
    desc='#{=/100/...:#{?key_note,#{key_note},#{key_command}}}'
    tmux list-keys -T "$1" -F "#{key_table}$tab#{q:key_string}$tab#{p12:$label} $desc$tab#{key_command}"
  else
    # Note: tmux before 3.5 and psmux lack list-keys -F, so parse the default
    # listing (bind-key [-r] -T table key command), which escapes the key, and
    # the notes listing (prefix key note), which does not. psmux ignores -P,
    # always printing its own prefix, so ask tmux for one too, to strip.
    { tmux list-keys -N -P "$prefix " -T "$1"; echo; tmux list-keys -T "$1"; } |
    awk -v table="$1" -v prefix="$prefix" -v tab="$tab" '
      !plain && /^$/ { plain = 1; next }
      !plain {
        sub(/^ *[^ ]+ +/, ""); key = $1; sub(/^[^ ]+ +/, ""); note[key] = $0; next
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
# before that, or with --run, run the binding's command instead.
# Note: psmux's source-file runs only some commands (such as set), so --run
# passes the command to tmux's command line, whose quoting sh shares. And it
# does so from a tmux job, since psmux ends this script's background processes
# along with the popup; the job's own shell is PowerShell, which runs sh too.
if [ "$run" ]; then
  printf '%s\n' "$choice" | cut -f4- > "$out"
  tmux run-shell "sh '$(pwd)/palette.sh' --exec '$out'" >/dev/null 2>&1 &
  # Note: Wait for the job to start, since closing the popup ends this tmux.
  sleep 0.3
  exit
fi
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
