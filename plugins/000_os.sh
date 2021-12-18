test "$DEBUG" && echo "[dotfiles] Loading plugin 'os'..."

# --== operating system (Darwin, Linux, etc.) ==--

export OS_NAME="$(uname)"
case "$OS_NAME" in
	Darwin)
		export IS_MACOS=1
		;;
	Linux)
		export IS_LINUX=1
		;;
	CYGWIN*)
		export IS_WINDOWS=1
		;;
esac

# --== ls ==--

# use readable ls colors
if [ "$IS_LINUX" ]; then
	alias ls='ls -AF --color=auto'
	export LS_COLORS="ow=30;42"
else
	alias ls='ls -AFG'
fi
if [ "$IS_MACOS" ]; then
	export LSCOLORS="ExGxBxDxCxEgedabagacad"
fi

# --== open ==--

# open a file with the default application using 'open'
if [ "$IS_MACOS" ]; then
	: The 'open' program is built-in on macOS
elif [ "$IS_LINUX" ]; then
	alias open='xdg-open'
elif [ "$IS_WINDOWS" ]; then
	alias open='cmd /c start'
fi
alias o=open

# --== sed ==--

# make in-place sed editing consistent across OSes
if [ "$IS_MACOS" ]; then
	# BSD sed requires a space after -i argument
	alias sedi="sed -i ''"
else
	# GNU sed requires no space after -i argument
	alias sedi="sed -i''"
fi
