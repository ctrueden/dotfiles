# "where is" - find a command or filename
wi() {
	cmd=$(which "$@" 2> /dev/null)
	if [ -z "$cmd" ]
	then
		# no command found; see if git knows about it
		git_files=$(git ls-files "*$@")
		if [ -z "$git_files" ]
		then
			# no file known to git; do a brute search
			files=$(find . -name "$@" | grep -v 'build/')
			if [ ! -z "$files" ]
			then
				echo "$files"
			fi
		else
			echo "$git_files"
		fi
	else
		echo "$cmd"
	fi
}

# jump to the folder containing the searched-for argument
goto() { cd "$(dirname "$(echo "$(wi "$@")" | head -n 1)")"; }

alias asdf='cd $HOME && clear'
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias up4='cd ../../../..'
alias up5='cd ../../../../..'
alias up6='cd ../../../../../..'
alias up7='cd ../../../../../../..'
alias up8='cd ../../../../../../../..'
alias up9='cd ../../../../../../../../..'
alias upa='cd ../../../../../../../../../..'
alias upb='cd ../../../../../../../../../../..'
alias upc='cd ../../../../../../../../../../../..'
alias upd='cd ../../../../../../../../../../../../..'
alias upe='cd ../../../../../../../../../../../../../..'
alias upf='cd ../../../../../../../../../../../../../../..'
alias upx='git rev-parse && cd "$(git rev-parse --show-cdup)"'
