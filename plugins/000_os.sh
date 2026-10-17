# --== operating system (Darwin, Linux, etc.) ==--

export OS_NAME="$(uname)"
case "$OS_NAME" in
	Darwin)
		export IS_MACOS=1
		;;
	FreeBSD)
		export IS_FREEBSD=1
		;;
	Linux)
		export IS_LINUX=1
		;;
	CYGWIN*|MINGW*|MSYS*)
		export IS_WINDOWS=1
		;;
	*)
		echo "Warning: unknown OS '$OS_NAME'; skipping OS-specific settings." >&2
		;;
esac

# --== sed ==--

# make in-place sed editing consistent across OSes
if [ "$IS_MACOS" ] || [ "$IS_FREEBSD" ]; then
	# BSD sed requires a space after -i argument
	alias sedi="sed -i ''"
elif [ "$IS_LINUX" ] || [ "$IS_WINDOWS" ]; then
	# GNU sed requires no space after -i argument
	alias sedi="sed -i''"
fi
