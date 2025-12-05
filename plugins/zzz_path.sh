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
path_prepend "$HOME"/.local/bin  # Python (uv, Linux)
macPythonDir=$(echo "$HOME"/Library/Python/*/bin | head -n1) 2>/dev/null
path_prepend "$macPythonDir"     # Python (macOS system)
path_prepend "$HOME"/bin

path_update
