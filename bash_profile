# Note: Bash has no file it reads for every shell, as zsh has ~/.zshenv; so
# for non-interactive login shells, this is where the PATH gets assembled.
. "$DOTFILES"/lib/path.sh

case $- in
	*i*) [ -r ~/.bashrc ] && source ~/.bashrc ;;
esac
