test "$DEBUG" && echo "[dotfiles] Loading plugin 'path'..."

# prepend Homebrew bin directories to the path, if applicable
if [ -d "$BREW" ]
then
	for dir in bin sbin opt/ruby/bin opt/util-linux/bin opt/util-linux/sbin
	do
		path_prepend "$BREW/$dir"
	done
fi

path_prepend /snap/bin
path_prepend /usr/local/bin
path_prepend "$HOME"/.local/bin            # Python (uv, Linux)
path_prepend "$HOME"/Library/Python/*/bin  # Python (macOS)
path_prepend "$HOME"/bin
path_prepend "$HOME"/.npm/bin

path_update
