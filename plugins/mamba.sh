test "$DEBUG" && echo "[dotfiles] Loading plugin 'mamba'..."

# Yes, the CONDA_PREFIX variable will hold this same directory later,
# thanks to conda/mamba's injected block in bashrc/zshrc. But it happens
# too late, after this and other plugins have already been sourced.
for dir in "$HOME/miniforge3" "$BREW/Caskroom/miniforge/base"; do
  if [ -x "$dir/bin/mamba" ]; then
    export MAMBA_DIR="$dir"
    break
  fi
done

snk-base-check() {
  # NB: Fail fast if we are in a non-base environment!
  # Otherwise, it's too easy to install packages by accident into base.
  local base=
  if [ "$CONDA_PREFIX" != "${CONDA_PREFIX%/base}" \
    -o "$CONDA_PREFIX" = "${CONDA_PREFIX%/envs/*}" ]
  then
    echo "Aborting because you are in the base environment. Activate something else."
    return 1
  fi
}

# Add handy shortcuts for efficient mamba usage.
alias snk='snk-base-check && mamba'
alias snka='mamba activate'
alias snkd='mamba deactivate'
alias snke='mamba env'
alias snkc='mamba create -n'
alias snkl='mamba list'
