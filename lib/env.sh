# Loads lib/env.conf into the environment of a shell. Sourced by ~/.zshenv (so
# every zsh gets it), ~/.bash_profile and bashrc; the same file reaches
# non-shell programs through systemd, per setup.sh.
#
# Note: Sourcing it again is harmless. Keep it fast: zsh runs this for every
# shell, scripts included.
set -a
. "${DOTFILES:?}"/lib/env.conf
set +a
