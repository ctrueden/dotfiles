export PATH=\
$HOME/bin:\
$PATH_SCRIPTS:\
$PATH_SCIJAVA/scijava-scripts:\
$PATH_FIJI/bin:\
$PATH

# prepend Homebrew bin directories to the path, if applicable
if [ -d "$BREW/sbin" ]; then
	export PATH="$BREW/sbin:$PATH"
fi
if [ -d "$BREW/bin" ]; then
	export PATH="$BREW/bin:$PATH"
fi
