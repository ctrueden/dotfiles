# Terminal multiplexer auto-launch, shared by zshrc and bashrc: byobu where it
# is installed, otherwise plain tmux for SSH logins (e.g. TrueNAS), or psmux
# on Windows.
#
# Both shells source this first thing, so the outer shell (which just waits on
# the multiplexer) starts up fast. It covers login shells (e.g. ssh, iTerm2 on
# macOS) and non-login ones (e.g. kitty on Linux) alike, which is why
# setup/byobu strips the launch lines that byobu-enable adds to the profiles.
#
# To skip the multiplexer:
#   LC_BYOBU=0 ssh <host>   - for one SSH login (ssh sends LC_* by default)
#   BYOBU_DISABLE=1 <shell> - for one local shell
#   autolaunch off          - for every new shell on this machine

_mux_embedded_terminal() {
	test -n "$NVIM" ||                                  # Neovim's :terminal.
	test -n "$VIM_TERMINAL" ||                          # Vim's :terminal.
	test "$TERM_PROGRAM" = vscode ||                    # VS Code and its forks.
	test "$TERMINAL_EMULATOR" = JetBrains-JediTerm      # IntelliJ and friends.
}

# Note: Git's zsh, an MSYS2 build, reports its OSTYPE as cygwin.
_mux_windows() {
	case $OSTYPE in cygwin*|msys*) ;; *) return 1 ;; esac  # Git Bash on Windows.
}

_mux_wanted() {
	case $- in *i*) ;; *) return 1 ;; esac             # Scripts and commands (zsh -c).
	test -z "$TMUX" || return 1                         # Already inside tmux.
	test "$LC_BYOBU" != 0 || return 1                   # Opted out for this login.
	test "$BYOBU_DISABLE" != 1 || return 1              # Opted out for this shell.
	test ! -e "$HOME/.config/byobu/disable-autolaunch" || return 1  # autolaunch off.
	! _mux_embedded_terminal                            # Editors and IDEs host their own.
}

# Note: The tmux server keeps the PATH of the shell that starts it, for the
# commands it runs itself (e.g. the palette's fzf, or the editor that opens
# scrollback), and the plugins have yet to add the user bin dirs to it.
# Duplicates are harmless; path_update filters them out.
if _mux_wanted; then
	_byobu_launch=$(command -v byobu-launch)
	if test -n "$_byobu_launch"; then
		export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
		# Note: byobu-launch is POSIX sh, and fails under zsh's own rules: e.g.
		# with nomatch, a glob for a missing /dev/shm/byobu-* run directory
		# aborts its setup, leaving it to mkdir /cache.tmux.
		if test -n "$ZSH_VERSION"; then
			emulate sh -c '_byobu_sourced=1 . "$_byobu_launch"'
		else
			_byobu_sourced=1 . "$_byobu_launch"
		fi
	elif test -n "$SSH_CONNECTION" && command -v tmux >/dev/null; then
		# Note: Plain tmux is only for SSH logins; locally, the terminal is the
		# session. And exec, so that leaving tmux (exit or detach) ends the SSH session.
		export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
		exec tmux new-session -A -s main
	elif _mux_windows && command -v psmux >/dev/null; then
		# Note: psmux is tmux for Windows, launched locally as byobu is elsewhere.
		# And exec, so that leaving psmux (exit or detach) closes the terminal tab.
		# Join any existing session, whatever its name, so that tabs stay together.
		export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
		psmux has-session 2>/dev/null && exec psmux attach-session
		exec psmux new-session
	fi
	unset _byobu_launch
fi

# Note: LC_BYOBU=0 opts out of this login only; unset, it is not passed on to
# the SSH sessions started from here, which should launch as usual.
test "$LC_BYOBU" = 0 && unset LC_BYOBU
unset -f _mux_embedded_terminal _mux_windows _mux_wanted
