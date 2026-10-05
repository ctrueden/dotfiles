# Startup progress reporting, shared by zshrc and bashrc.
#
#   _progress_init <total>  - Begin; <total> is the number of _progress calls to come.
#   _progress <label>       - Report the next step: a debug line if DEBUG is set,
#                             otherwise an in-place progress bar (interactive terminals only).
#   _progress_done          - Clear the bar and clean up.

_progress_init() {
	_progress_total=$1
	_progress_n=0
	_progress_bar=
	test -z "$DEBUG" && test -t 2 && _progress_bar=1
}

_progress() {
	if test "$DEBUG"
	then
		echo "[dotfiles] Loading $1..."
		return 0
	fi
	test "$_progress_bar" || return 0
	local filled=$((20 * _progress_n / _progress_total)) bar= i=0
	while test $i -lt 20
	do
		if test $i -lt $filled; then bar="$bar#"; else bar="$bar-"; fi
		i=$((i + 1))
	done
	printf '\r\033[K[%s] %s' "$bar" "$1" >&2
	_progress_n=$((_progress_n + 1))
}

_progress_done() {
	test "$_progress_bar" && printf '\r\033[K' >&2
	unset _progress_total _progress_n _progress_bar
	unset -f _progress_init _progress _progress_done
}
