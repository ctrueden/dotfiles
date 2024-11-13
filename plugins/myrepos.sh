test "$DEBUG" && echo "[dotfiles] Loading plugin 'myrepos'..."

alias mr='mr --stats'

mrln() {
	for cfg in $@
	do (
		set -x && ln -s "$DOTFILES/mrconfig.d/$cfg" "$HOME/.config/mr/"
	) done
}

mrrm() {
	for cfg in $@
	do (
		set -x && rm "$HOME/.config/mr/$cfg"
	) done
}
