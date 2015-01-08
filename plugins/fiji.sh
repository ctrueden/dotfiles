case "$(uname)" in
	Darwin)
		export PATH_FIJI_USER="/Applications/Fiji.app"
		export FIJI_EXEC="$PATH_FIJI_USER/Contents/MacOS/ImageJ-macosx"
		;;
	CYGWIN*)
		export PATH_FIJI_USER="$HOME/Applications/Fiji.app"
		export FIJI_EXEC="$PATH_FIJI_USER/ImageJ-win64"
		;;
	Linux)
		export PATH_FIJI_USER="$HOME/Applications/Fiji.app"
		export FIJI_EXEC="$PATH_FIJI_USER/ImageJ-linux64"
esac
alias fiji='$FIJI_EXEC'
alias fiji6='$FIJI_EXEC --java-home "$J6"'
alias fiji7='$FIJI_EXEC --java-home "$J7"'
alias fiji8='$FIJI_EXEC --java-home "$J8"'
