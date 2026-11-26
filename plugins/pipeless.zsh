# use ctrl+~ (ctrl+shift+` on USA keyboard layout) for paging stdout+stderr
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
bindkey "^~" pipeless
