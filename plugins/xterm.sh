# update terminal title as appropriate
case "$TERM" in
	xterm*|rxvt*)
		PROMPT_COMMAND='
			if [ -n "$TERM_TITLE" ]
			then
				echo -ne "\033]0;$TERM_TITLE\007"
			else
				echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
			fi
		'
		;;
	*)
		;;
esac
