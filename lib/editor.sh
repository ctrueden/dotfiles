# Editor choice, shared by zshrc and bashrc: nvim, else vim, else vi.
#
# Note: Both shells source this before lib/multiplexer.sh, so that the tmux
# client sends EDITOR and VISUAL on attach (see update-environment in
# tmux/tmux.conf), for programs opening an editor in a new window.

for _editor in nvim vim vi
do
	if command -v "$_editor" >/dev/null; then
		export EDITOR="$_editor" VISUAL="$_editor"
		break
	fi
done
unset _editor
