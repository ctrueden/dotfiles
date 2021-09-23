test "$DEBUG" && echo "[dotfiles] Loading plugin 'conda'..."

condaSetupScript="$HOME/.cache/conda-setup"

# Adapted from "conda init" blurb, but cached for performance.
if [ ! -f "$condaSetupScript" ]
then
	for condaDir in "$HOME/miniconda3" /usr/local/miniconda
	do
		__conda_setup="$("$condaDir/bin/conda" "shell.$(shell_name)" hook 2>/dev/null)"
		if [ $? -eq 0 ]; then
			mkdir -p "$(dirname "$condaSetupScript")"
			echo -E "$__conda_setup" >"$condaSetupScript"
		elif [ -f "$condaDir/etc/profile.d/conda.sh" ]; then
			mkdir -p "$(dirname "$condaSetupScript")"
			echo ". '$condaDir/etc/profile.d/conda.sh'" >"$condaSetupScript"
		fi
		unset __conda_setup
		test -f "$condaSetupScript" && break
	done
fi

# Enable conda.
if [ -f "$condaSetupScript" ]; then
	. "$condaSetupScript"
fi
unset condaSetupScript

# Enable mamba if available.
if [ -f "$CONDA_PREFIX/etc/profile.d/mamba.sh" ]; then
	. "$CONDA_PREFIX/etc/profile.d/mamba.sh"
fi

# NB: Explicitly call compinit. Isn't needed for most completions,
# but the esc/conda-zsh-completion plugin doesn't work without it.
which compinit >/dev/null 2>&1 && test -x "$CONDA_EXE" && compinit
