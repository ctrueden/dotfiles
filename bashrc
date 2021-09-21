# if not running interactively, don't do anything
[ -z "$PS1" ] && return

test "$DEBUG" && echo "[bashrc] Initializing..."

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# path to Homebrew (if installed)
which brew > /dev/null 2>&1 && export BREW=$(brew --prefix)

# --== bash completion ==--

test "$DEBUG" && echo "[bashrc] Configuring bash completion..."

if [ -f /etc/bash_completion ]; then
	# Ubuntu Linux
	. /etc/bash_completion

	# NB: Workaround for environment variable expansion bug in bash 4.2+.
	# See: http://askubuntu.com/q/41891
	if ((BASH_VERSINFO[0] >= 4)) && \
		((BASH_VERSINFO[1] >= 2)) && \
		((BASH_VERSINFO[2] >= 29))
	then
		shopt -s direxpand
	fi
fi
if [ -f "$BREW/etc/bash_completion" ]; then
	# Mac OS X with Homebrew ("brew install bash-completion")
	. "$BREW/etc/bash_completion"
fi

# --== git ==--

test "$DEBUG" && echo "[bashrc] Configuring git completion..."

# enable bash completion of git commands
if [ -f /etc/bash_completion.d/git-prompt ]; then
	# newer Ubuntu Linux ("sudo aptitude install bash-completion")
	. /etc/bash_completion.d/git-prompt # in case of no /etc/bash_completion
elif [ -f /etc/bash_completion.d/git ]; then
	# older Ubuntu Linux ("sudo aptitude install bash-completion")
	# or Cygwin ("apt-cyg install bash-completion")
	. /etc/bash_completion.d/git # in case of no /etc/bash_completion
fi

# --== shell prompt ==--

test "$DEBUG" && echo "[bashrc] Configuring shell prompt..."

SHELL_PROMPT=': ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\] \[\033[01;34m\]\w'

if [ "$(__git_ps1 x 2> /dev/null)" = "x" ]; then
	# make shell prompt reflect current git status+branch
	PS1="$SHELL_PROMPT"'\[\033[01;32m\]$(__git_ps1)\[\033[00m\]\n'
else
	PS1="$SHELL_PROMPT"'\[\033[00m\]\n'
fi

# --== bash ==--

test "$DEBUG" && echo "[bashrc] Enabling bash vi mode..."

# use vi commands for advanced editing (hit ESC to enter command mode)
set -o vi

# --== hub (http://hub.github.com/) ==--

command -v hub >/dev/null 2>&1 && \
	alias git='hub'

# --== shell plugins ==--

for f in $DOTFILES/plugins/*.sh
do
	test "$DEBUG" && echo "[bashrc] Sourcing plugin $(basename "$f")..."
	source $f
done

export PERL5LIB="$CODE_GIT/perl:$CODE_GIT/contrib/mw-to-git"

# Local customized path and environment settings, etc.
if [ -f ~/.bash_local ]; then
	test "$DEBUG" && echo "[bashrc] Sourcing ~/.bash_local..."
	. ~/.bash_local
fi

test "$DEBUG" && echo "[bashrc] Done!"
