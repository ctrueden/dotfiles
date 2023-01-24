test "$DEBUG" && echo "[dotfiles] Loading plugin 'fiji'..."

ij() {
  ijexe=
  bits=$(getconf LONG_BIT 2>/dev/null)
  test "$bits" || bits=64
  case "$(uname -s 2>/dev/null)" in
    Darwin) ijexe=Contents/MacOS/ImageJ-macosx ;;
    CYGWIN*|MINGW*) ijexe=ImageJ-win"$bits".exe ;;
    Linux) ijexe=ImageJ-linux"$bits" ;;
		*) ijexe=ImageJ.sh
  esac
  ijcmd=
  for dir in . \
		~/Applications/ImageJ2.app ~/Applications/Fiji.app \
		/Applications/ImageJ2.app /Applications/Fiji.app
  do
    test -x "$dir/$ijexe" && ijcmd="$dir/$ijexe" && break
  done
  if [ -x "$ijcmd" ]
  then
    "$ijcmd" $@
  else
    echo "No ImageJ executable found."
    return 1
  fi
}

# HACK: The ImageJ Launcher is supposed to pick up on JAVA_HOME by default.
# But at least on macOS, the Launcher has been broken in this respect for
# quite a long time. So to be safe, let's pass it explicitly, which works.
alias ij6='j6; ij --java-home "$JAVA_HOME"'
alias ij7='j7; ij --java-home "$JAVA_HOME"'
alias ij8='j8; ij --java-home "$JAVA_HOME"'
alias ij9='j9; ij --java-home "$JAVA_HOME"'
alias ij10='j10; ij --java-home "$JAVA_HOME"'
alias ij11='j11; ij --java-home "$JAVA_HOME"'
alias ij12='j12; ij --java-home "$JAVA_HOME"'
alias ij13='j13; ij --java-home "$JAVA_HOME"'
alias ij14='j14; ij --java-home "$JAVA_HOME"'
alias ij15='j15; ij --java-home "$JAVA_HOME"'
alias ij16='j16; ij --java-home "$JAVA_HOME"'
alias ij17='j17; ij --java-home "$JAVA_HOME"'
alias ij18='j18; ij --java-home "$JAVA_HOME"'
alias ij19='j19; ij --java-home "$JAVA_HOME"'
alias ij20='j20; ij --java-home "$JAVA_HOME"'
alias ij21='j21; ij --java-home "$JAVA_HOME"'
alias ij22='j22; ij --java-home "$JAVA_HOME"'
alias ij23='j23; ij --java-home "$JAVA_HOME"'
alias ij24='j24; ij --java-home "$JAVA_HOME"'
alias ij25='j25; ij --java-home "$JAVA_HOME"'
alias ij26='j26; ij --java-home "$JAVA_HOME"'
alias ij27='j27; ij --java-home "$JAVA_HOME"'
alias ij28='j28; ij --java-home "$JAVA_HOME"'
alias ij29='j29; ij --java-home "$JAVA_HOME"'
alias ij30='j30; ij --java-home "$JAVA_HOME"'
alias ij31='j31; ij --java-home "$JAVA_HOME"'
alias ij8z='j8z; ij --java-home "$JAVA_HOME"'
alias ij11z='j11z; ij --java-home "$JAVA_HOME"'
alias ij17z='j17z; ij --java-home "$JAVA_HOME"'
