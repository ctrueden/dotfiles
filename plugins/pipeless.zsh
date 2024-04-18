test "$DEBUG" && echo "[dotfiles] Loading zsh plugin 'pipeless'..."

# use ctrl+~ (ctrl+shift+` on USA keyboard layout) for paging stdout+stderr
pipeless () {
	[[ -z $BUFFER ]] && zle up-history
	pager=$PAGER
	test "$pager" || pager=less
	SUFFIX=" 2>&1 | $pager"
	if [[ $BUFFER == *"$SUFFIX" ]]
	then
		BUFFER="${BUFFER%$SUFFIX}"
	else
		BUFFER="$BUFFER$SUFFIX"
	fi
}
zle -N pipeless
bindkey "^~" pipeless
