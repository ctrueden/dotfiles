test "$DEBUG" && echo "[dotfiles] Loading plugin 'mamba'..."

snk-base-check() {
  # NB: Fail fast if we are in the base environment!
  # Otherwise, it's too easy to install packages by accident into base.
  if [ "$CONDA_PREFIX" -a "$CONDA_PREFIX" != "${CONDA_PREFIX%/base}" ]
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
