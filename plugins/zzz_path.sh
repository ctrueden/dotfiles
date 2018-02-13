export PATH=\
$HOME/bin:\
$CODE_SCRIPTS:\
$CODE_SCIJAVA/scijava-scripts:\
$CODE_FIJI/bin:\
$PATH

# prepend Miniconda bin directory to the path, if applicable
MINICONDA_DIR=/usr/local/miniconda3/bin
if [ -d "$MINICONDA_DIR" ]; then
	export PATH="$MINICONDA_DIR:$PATH"
fi

# prepend Homebrew bin directories to the path, if applicable
if [ -d "$BREW/sbin" ]; then
	export PATH="$BREW/sbin:$PATH"
fi
if [ -d "$BREW/bin" ]; then
	export PATH="$BREW/bin:$PATH"
fi
