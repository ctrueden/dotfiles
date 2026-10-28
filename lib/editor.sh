# Editor choice, shared by zshrc and bashrc: nvim, else vim, else vi.

for _editor in nvim vim vi
do
	if command -v "$_editor" >/dev/null; then
		export EDITOR="$_editor" VISUAL="$_editor"
		break
	fi
done
unset _editor
