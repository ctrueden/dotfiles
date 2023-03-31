test "$DEBUG" && echo "[dotfiles] Loading bash plugin 'open'..."

# open a file with the default application using 'open'
if [ "$IS_MACOS" ]; then
	: The 'open' program is built-in on macOS
elif [ "$IS_LINUX" ]; then
	alias open='xdg-open'
elif [ "$IS_WINDOWS" ]; then
	alias open='cmd /c start'
fi
