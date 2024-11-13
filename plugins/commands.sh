test "$DEBUG" && echo "[dotfiles] Loading plugin 'commands'..."

# --== xterm ==--

alias xterm='xterm -geometry 80x60 -fg white -bg black'

# --== bat ==--

test -x /usr/bin/batcat && alias bat=batcat
export BAT_THEME=TwoDark

# --== 7z ==--

# "7-zip compress" -- solid mode -- https://stackoverflow.com/a/52771612
alias 7zc='7za a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=29 -ms=8g -mmt=off -mmtf=off -mqs=on -bt -bb3'

# --== shell ==--

# Print a dividing line in ASCII.
div() {
	local len=$1
  test "$len" -gt 0 2>/dev/null || len=$((COLUMNS-1)) 2>/dev/null
	test "$len" -gt 0 || len=36
	local symbol=$2
	test "$symbol" || symbol=—
  local div=
  for i in $(seq "$len"); do div="$div$symbol"; done
  echo "$div"
}

alias mv='mv -i'
# NB: To get clear on Cygwin, install ncurses.
alias cls='clear;pwd;div;ls'
alias cll='clear;pwd;div;ls -la'
alias cdiff='colordiff 2> /dev/null'
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias rgrep='grep -IR --exclude="*\.svn*"'
alias f='find . -name'
alias o=open
alias off='shutdown -h now'
alias offon='shutdown -r now'

# --== version reporting ==--

# report details of the OS using 'version'
version() {
	test -x "$(command -v sw_vers)" && sw_vers
	test -e /proc/version && cat /proc/version
	test -x "$(command -v lsb_release)" && lsb_release -a
	test -e /etc/redhat-release && cat /etc/redhat-release
	test -x "$(command -v ver)" && ver
}

# --== counting occurrences ==--

alias count='LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr'

# --== history ==--

alias histime='HISTTIMEFORMAT="%F %T " history'

# --== eject ==--

if [ -x "$(command -v diskutil)" ]; then
  alias eject='diskutil eject'
fi

# --== ldd ==--

if [ ! -x "$(command -v ldd)" ]; then
	# make 'ldd' work on OS X
	alias ldd='otool -L'
fi

# --== hex editor ==--

# open a graphical hex editor using 'hex'
if [ -x "$(command -v ghex2)" ]; then
	alias hex='ghex2'
elif [ -d '/Applications/Hex Fiend.app' ]; then
	alias hex="'/Applications/Hex Fiend.app/Contents/MacOS/Hex Fiend'"
fi

# --== tab removal ==--

# remove tabs from files using 'detab'
alias detab="sedi -e 's/	/  /g'"

# --== gravatars ==--

gravhash() {
	php -r "echo md5(strtolower(trim('$@'))) . \"\n\";"
}

# --== youtube-dl ==--

alias dlv='youtube-dl -i --sleep-interval 3 --max-sleep-interval 10'
alias dla='youtube-dl -i --sleep-interval 3 --max-sleep-interval 10 -x'
