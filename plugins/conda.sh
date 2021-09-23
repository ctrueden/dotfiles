test "$DEBUG" && echo "[dotfiles] Loading plugin 'conda'..."

for condaDir in "$HOME/miniconda3" /usr/local/miniconda
do
	# Adapted from "conda init" blurb.
	__conda_setup="$("$condaDir/bin/conda" "shell.$(shell_name)" hook 2>/dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	elif [ -f "$condaDir/etc/profile.d/conda.sh" ]; then
		. "$condaDir/etc/profile.d/conda.sh"
	fi
	unset __conda_setup
	test -x "$CONDA_EXE" && break
done

# Enable mamba if available.
if [ -f "$CONDA_PREFIX/etc/profile.d/mamba.sh" ]; then
	. "$CONDA_PREFIX/etc/profile.d/mamba.sh"
fi

# NB: Explicitly call compinit. Isn't needed for most completions,
# but the esc/conda-zsh-completion plugin doesn't work without it.
which compinit >/dev/null 2>&1 && test -x "$CONDA_EXE" && compinit
