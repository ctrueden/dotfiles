test "$DEBUG" && echo "[dotfiles] Loading plugin $(basename "$0")..."

# Enable conda if installed.
if [ -d "$HOME/miniconda3" ]
then
  . "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -d /usr/local/miniconda3 ]
then
  . /usr/local/miniconda3/etc/profile.d/conda.sh
fi

# Prefer mamba to conda where feasible, if mamba is installed.
if which mamba >/dev/null 2>&1
then
  export MAMBA_EXE=$(which mamba)
  export CONDA_EXE=$MAMBA_EXE
fi
