test "$DEBUG" && echo "[dotfiles] Loading plugin 'path'..."

export PATH=\
$HOME/bin:\
$CODE_SCRIPTS:\
$CODE_SCIJAVA/scijava-scripts:\
$CODE_FIJI/bin:\
/snap/bin:\
$PATH

# prepend Homebrew bin directories to the path, if applicable
for dir in bin sbin opt/ruby/bin
do
	if [ -d "$BREW/$dir" ]; then
		export PATH="$BREW/$dir:$PATH"
	fi
done

# prepend local Ruby bin directory to the path, if applicable
localGemDir=$(gem env 2>/dev/null | grep 'USER INSTALLATION DIRECTORY' | sed 's/.*: //')
if [ -d "$localGemDir" -a -d "$localGemDir/bin" ]; then
	export PATH="$localGemDir/bin:$PATH"
fi
