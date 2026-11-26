# use ctrl+6 to toggle paging of stdout+stderr on the command line
# Note: ctrl+6 sends ^^ in most terminals. So would ctrl+~ in principle, but
# terminals like kitty reserve ctrl+shift chords for their own shortcuts.
pipeless () {
	[[ -z $BUFFER ]] && zle up-history
	local suffix=" 2>&1 | ${PAGER:-less}"
	if [[ $BUFFER == *"$suffix" ]]
	then
		BUFFER="${BUFFER%$suffix}"
	else
		BUFFER="$BUFFER$suffix"
	fi
}
zle -N pipeless
bindkey "^^" pipeless
