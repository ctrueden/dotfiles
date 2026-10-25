# --== xterm ==--

alias xterm='xterm -geometry 80x60 -fg white -bg black'

# --== bat ==--

test -x /usr/bin/batcat && alias bat=batcat
export BAT_THEME=TwoDark

# --== 7z ==--

# "7-zip compress" -- solid mode -- https://stackoverflow.com/a/52771612
alias 7zc='7za a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=29 -ms=8g -mmt=off -mmtf=off -mqs=on -bt -bb3'

# --== ls ==--

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

# use readable ls colors
if [ "$IS_LINUX" ] || [ "$IS_WINDOWS" ]; then
	alias ls='ls -F --color=auto'
	export LS_COLORS="ow=30;42"
elif [ "$IS_MACOS" ] || [ "$IS_FREEBSD" ]; then
	alias ls='ls -FG'
	export LSCOLORS="ExGxBxDxCxEgedabagacad"
fi

lhelp() {
	echo "
    Command   Style    Hidden
    -------   -----    ------
    ls        column   none
    lsA       column   most
    lsa       column   all
    ll        long     none
    llA       long     most
    lla       long     all

    A = hidden excluding . and ..
    a = hidden including . and ..

    c prefix: clear screen before listing
    t suffix: sort by last modified time
    S suffix: sort by file size

    Aliases: s for S, l for ll (mostly)
"
}
alias lh=lhelp

# -- File listing shortcuts, assigned with consistency! --

if [ -x /usr/bin/clear ]; then
	# NB: We hardcode the path to the clear command if possible,
	# because in some scenarios (e.g. in a conda environment),
	# ncurses overrides it with its own inferior one.
	clr() { /usr/bin/clear; pwd; div; }
else
  # NB: To get clear on Cygwin, install ncurses.
	clr() { clear; pwd; div; }
fi

# columnar, no hidden files
                     alias cls='clr;ls'      # ls is the base command ;-)
alias lst='ls -t';   alias clst='clr;lst'
alias lsS='ls -S';   alias clsS='clr;lsS'
alias lss=lsS;       alias clss=clsS

# columnar, most hidden files
alias lsA='ls -A';   alias clsA='clr;lsA'
alias lsAt='lsA -t'; alias clsAt='clr;lsAt'
alias lsAS='lsA -S'; alias clsAS='clr;lsAS'
alias lsAs=lsAS;     alias clsAs=clsAS

# columnar, all hidden files
alias lsa='ls -a';   alias clsa='clr;lsa'    # Overrides omz lsa='ls -lah'
alias lsat='lsa -t'; alias clsat='clr;lsat'
alias lsaS='lsa -S'; alias clsaS='clr;lsaS'
alias lsas=lsaS;     alias clsas=clsaS

# long, no hidden files
alias ll='ls -lh';   alias cll='clr;ll'      # Overrides omz ll='ls -lh'
alias llt='ll -t';   alias cllt='clr;llt'
alias llS='ll -S';   alias cllS='clr;llS'
alias lls=llS;       alias clls=cllS
alias l=ll;          alias cl=cll            # Overrides omz l='ls -lah'
alias lt=llt;        alias clt=cllt
alias lS=llS;        alias clS=cllS
#alias ls=lls;       alias cls=clls          # ls and cls would name clash

# long, most hidden files
alias llA='ll -A';   alias cllA='clr;llA'
alias llAt='llA -t'; alias cllAt='clr;llAt'
alias llAS='llA -S'; alias cllAS='clr;llAS'
alias llAs=llAS;     alias cllAs=cllAS
alias lA=llA;        alias clA=cllA
alias lAt=llAt;      alias clAt=cllAt
alias lAS=llAS;      alias clAS=cllAS
alias lAs=llAs;      alias clAs=cllAs

# long, all hidden files
alias lla='ll -a';   alias clla='clr;lla'
alias llat='lla -t'; alias cllat='clr;llat'
alias llaS='lla -S'; alias cllaS='clr;llaS'
alias llas=llaS;     alias cllas=cllaS
alias la=lla;        alias cla=clla          # Overrides omz la='ls -lAh'
alias lat=llat;      alias clat=cllat
alias laS=llaS;      alias claS=cllaS
alias las=llas;      alias clas=cllas

# --== various ==--

alias mv='mv -i'
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
	has sw_vers && sw_vers
	test -e /proc/version && cat /proc/version
	has lsb_release && lsb_release -a
	test -e /etc/redhat-release && cat /etc/redhat-release
	has ver && ver
}

# --== counting occurrences ==--

alias count='LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr'

# --== eject ==--

if has diskutil; then
	alias eject='diskutil eject'
fi

# --== ldd ==--

if ! has ldd; then
	# make 'ldd' work on OS X
	alias ldd='otool -L'
fi

# --== hex editor ==--

# open a graphical hex editor using 'hex'
if has ghex2; then
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

# --== yt-dlp ==--

alias dlv='yt-dlp -i --sleep-interval 3 --max-sleep-interval 10'
alias dla='yt-dlp -i --sleep-interval 3 --max-sleep-interval 10 -x'
