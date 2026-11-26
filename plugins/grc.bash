# The zpm-zsh/colorize plugin colorizes many commands.
# Unfortunately, the plugin only works in zsh, not bash.
# So, sadly, we replicate the aliases here. But only for bash.

if command -v grc >/dev/null; then
	alias as='grc --colour=auto as'
	alias df='grc --colour=auto df -h'
	alias dig='grc --colour=auto dig'
	alias du='grc --colour=auto du -h'
	alias env='grc --colour=auto env'
	alias free='grc --colour=auto free -h'
	alias g++='grc --colour=auto g++'
	alias gcc='grc --colour=auto gcc'
	alias ifconfig='grc --colour=auto ifconfig'
	alias last='grc --colour=auto last'
	alias ld='grc --colour=auto ld'
	alias lsblk='grc --colour=auto lsblk'
	alias lsmod='grc --colour=auto lsmod'
	alias lspci='grc --colour=auto lspci'
	alias mount='grc --colour=auto mount'
	alias mtr='grc --colour=auto mtr'
	alias netstat='grc --colour=auto netstat'
	alias ping='grc --colour=auto ping'
	alias ping6='grc --colour=auto ping6'
	alias ps='grc --colour=auto ps'
	alias ss='grc --colour=auto ss'
fi
