test "$DEBUG" && echo "[dotfiles] Loading plugin 'java'..."

# Define the java command to use the java executable from JAVA_HOME.
# - On macOS, this already happens indirectly.
# - On Linux, /bin/java and /usr/bin/java point at /etc/alternatives/java,
#   which is controlled system-wide by update-java-alternatives.
unset -f java 2>/dev/null
export SYSTEM_JAVA_BIN=$(dirname "$(command -v java)")

jexec() {
  : << 'DOC'
Launch a java command from the currently set JAVA_HOME's bin (or jre/bin)
folder. The first argument is the command to execute (e.g. javac),
and the remaining arguments are arguments to that command.
DOC
  cmd=$1
  shift
  if [ "$JAVA_HOME" -a -x "$JAVA_HOME/bin/$cmd" ]
  then
    "$JAVA_HOME/bin/$cmd" $@
  elif [ "$JAVA_HOME" -a -x "$JAVA_HOME/jre/bin/$cmd" ]
  then
    "$JAVA_HOME/jre/bin/$cmd" $@
  elif [ "$SYSTEM_JAVA_BIN" -a -x "$SYSTEM_JAVA_BIN/$cmd" ]
  then
    "$SYSTEM_JAVA_BIN/$cmd" $@
  else
    >&2 echo "No $cmd executable found."
  fi
}
alias java='jexec java'
alias javac='jexec javac'
alias javah='jexec javah'
alias javap='jexec javap'
alias javadoc='jexec javadoc'
alias jshell='jexec jshell'

jlist() {
  : << 'DOC'
List the available Java installations, for both the user and system-wide.
Installations are discovered beneath ~/Java/<platform> as well as
via the macOS java_home and Linux update-java-alternatives commands.
DOC
  # Java installations in ~/Java/<platform>.
  local dir=
  case "$(arch 2>/dev/null)-$(uname -s 2>/dev/null)" in
    i386-Darwin)                  dir=macos-x64 ;;
    aarch64-Darwin)               dir=macos-aarch64 ;;
    *86*64-CYGWIN*|amd64-CYGWIN*) dir=windows-x64 ;;
    *86*64-MINGW*|amd64-MINGW*)   dir=windows-x64 ;;
    *86-CYGWIN*|*86-MINGW*)       dir=windows-x86 ;;
    *86*64-Linux|amd64-Linux)     dir=linux-x64 ;;
    *86-Linux)                    dir=linux-x86 ;;
    *)                            ;; # unsupported platform
  esac
  local javas=
  if [ "$dir" -a -d "$HOME/Java/$dir" ]
  then
    javas=$(find "$HOME/Java/$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while read d
    do
      if [ -x "$d/bin/java" -o -x "$d/bin/java.exe" ]
      then
        echo "$d"
      elif [ -x "$d/Contents/Home/bin/java" ]
      then
        echo "$d/Contents/Home"
      fi
    done)
  fi

  # Java installations from java_home (macOS).
  if [ -x /usr/libexec/java_home ]
  then
    javas="$javas
$(/usr/libexec/java_home -V 2>&1 | grep jdk | sed 's/.* //')"
  fi

  # Java installations from update-java-alternatives (Linux).
  if [ -x /usr/sbin/update-java-alternatives ]
  then
    javas="$javas
$(/usr/sbin/update-java-alternatives -l | sed 's/.* //')"
  fi

  # Return union of results
  if [ $# -gt 0 ]
  then
    echo "$javas" | grep -v '^$' | sort -u | grep -- "$@"
  else
    echo "$javas" | grep -v '^$' | sort -u
  fi
}

jhome() {
  : << 'DOC'
Report the first Java installation matching the given arguments,
or the current value of JAVA_HOME if no arguments are given.
DOC
  if [ $# -eq 0 ]
  then
    echo "$JAVA_HOME"
  else
    jlist $@ | head -n1
  fi
}

jswitch() {
  : << 'DOC'
Switch the current shell's active Java installation to one matching
the given arguments. Accomplished by calling the jhome function and
setting JAVA_HOME to match.
DOC
  local result=$(jhome $@)
  test "$result" || {
    echo "No matching Java for arguments: $@"
    return 1
  }
  export JAVA_HOME="$result" &&
    echo "JAVA_HOME -> $JAVA_HOME" &&
    jexec java -version
}

alias j0='jswitch -1\.0' # 1996-01-23
alias j1='jswitch -1\.1' # 1997-02-02 (1.1.4=Sparkler; 1.1.6=Abigail; 1.1.7=Brutus; 1.1.8=Chelsea)
alias j2='jswitch -1\.2' # 1998-12-04 (Playground; 1.2.2=Cricket)
alias j3='jswitch -1\.3' # 2000-05-08 (Kestrel; 1.3.1=Ladybird)
alias j4='jswitch -1\.4' # 2002-02-13 (Merlin; 1.4.1=Hopper; 1.4.2=Mantis)
alias j5="jswitch '-\\(5[^0-9]\\|1\\.5\\)'" # 2004-09-29 (Tiger)
alias j6="jswitch '-\\(6[^0-9]\\|1\\.6\\)'" # 2006-12-11 (Mustang)
alias j7="jswitch '-\\(7[^0-9]\\|1\\.7\\)'" # 2011-07-28 (Dolphin)
alias j8="jswitch '-\\(8[^0-9]\\|1\\.8\\)'" # 2014-03-18 (Spider)
alias j9="jswitch '-\\(9[^0-9]\\|1\\.9\\)'" # 2017-09-21
alias j10="jswitch '-\\(10[^0-9]\\|1\\.10\\)'" # 2018-03-20
alias j11="jswitch '-\\(11[^0-9]\\|1\\.11\\)'" # 2018-09-25
alias j12="jswitch '-\\(12[^0-9]\\|1\\.12\\)'" # 2019-03-19
alias j13="jswitch '-\\(13[^0-9]\\|1\\.13\\)'" # 2019-09-17
alias j14="jswitch '-\\(14[^0-9]\\|1\\.14\\)'" # 2020-03-17
alias j15="jswitch '-\\(15[^0-9]\\|1\\.15\\)'" # 2020-09-15
alias j16="jswitch '-\\(16[^0-9]\\|1\\.16\\)'" # 2021-03-16
alias j17="jswitch '-\\(17[^0-9]\\|1\\.17\\)'" # 2021-09-14
alias j18="jswitch '-\\(18[^0-9]\\|1\\.18\\)'" # 2022-03-22
alias j19="jswitch '-\\(19[^0-9]\\|1\\.19\\)'" # 2022-09-20
alias j20="jswitch '-\\(20[^0-9]\\|1\\.20\\)'" # 2023-03-21
alias j21="jswitch '-\\(21[^0-9]\\|1\\.21\\)'" # 2023-09
alias j22="jswitch '-\\(22[^0-9]\\|1\\.22\\)'" # 2024-03
alias j23="jswitch '-\\(23[^0-9]\\|1\\.23\\)'" # 2024-09
alias j24="jswitch '-\\(24[^0-9]\\|1\\.24\\)'" # 2025-03
alias j25="jswitch '-\\(25[^0-9]\\|1\\.25\\)'" # 2025-09
alias j26="jswitch '-\\(26[^0-9]\\|1\\.26\\)'" # 2026-03
alias j27="jswitch '-\\(27[^0-9]\\|1\\.27\\)'" # 2026-09
alias j28="jswitch '-\\(28[^0-9]\\|1\\.28\\)'" # 2027-03
alias j29="jswitch '-\\(29[^0-9]\\|1\\.29\\)'" # 2027-09
alias j30="jswitch '-\\(30[^0-9]\\|1\\.30\\)'" # 2028-03
alias j31="jswitch '-\\(31[^0-9]\\|1\\.31\\)'" # 2028-09
alias j32="jswitch '-\\(32[^0-9]\\|1\\.32\\)'" # 2029-03
alias j33="jswitch '-\\(33[^0-9]\\|1\\.33\\)'" # 2029-09
alias j34="jswitch '-\\(34[^0-9]\\|1\\.34\\)'" # 2030-03
alias j35="jswitch '-\\(35[^0-9]\\|1\\.35\\)'" # 2030-09
alias j36="jswitch '-\\(36[^0-9]\\|1\\.36\\)'" # 2031-03
alias j37="jswitch '-\\(37[^0-9]\\|1\\.37\\)'" # 2031-09
alias j38="jswitch '-\\(38[^0-9]\\|1\\.38\\)'" # 2032-03
alias j39="jswitch '-\\(39[^0-9]\\|1\\.39\\)'" # 2032-09
alias j40="jswitch '-\\(40[^0-9]\\|1\\.40\\)'" # 2033-03
alias j41="jswitch '-\\(41[^0-9]\\|1\\.41\\)'" # 2033-09
alias j42="jswitch '-\\(42[^0-9]\\|1\\.42\\)'" # 2034-03
alias j43="jswitch '-\\(43[^0-9]\\|1\\.43\\)'" # 2034-09
alias j44="jswitch '-\\(44[^0-9]\\|1\\.44\\)'" # 2035-03
alias j45="jswitch '-\\(45[^0-9]\\|1\\.45\\)'" # 2035-09
alias j46="jswitch '-\\(46[^0-9]\\|1\\.46\\)'" # 2036-03
alias j47="jswitch '-\\(47[^0-9]\\|1\\.47\\)'" # 2036-09
alias j48="jswitch '-\\(48[^0-9]\\|1\\.48\\)'" # 2037-03
alias j49="jswitch '-\\(49[^0-9]\\|1\\.49\\)'" # 2037-09
alias j50="jswitch '-\\(50[^0-9]\\|1\\.50\\)'" # 2038-03
alias j51="jswitch '-\\(51[^0-9]\\|1\\.51\\)'" # 2038-09
alias j52="jswitch '-\\(52[^0-9]\\|1\\.52\\)'" # 2039-03
alias j53="jswitch '-\\(53[^0-9]\\|1\\.53\\)'" # 2039-09
alias j54="jswitch '-\\(54[^0-9]\\|1\\.54\\)'" # 2040-03
alias j55="jswitch '-\\(55[^0-9]\\|1\\.55\\)'" # 2040-09
alias j56="jswitch '-\\(56[^0-9]\\|1\\.56\\)'" # 2041-03
alias j57="jswitch '-\\(57[^0-9]\\|1\\.57\\)'" # 2041-09
alias j58="jswitch '-\\(58[^0-9]\\|1\\.58\\)'" # 2042-03
alias j59="jswitch '-\\(59[^0-9]\\|1\\.59\\)'" # 2042-09
alias j60="jswitch '-\\(60[^0-9]\\|1\\.60\\)'" # 2043-03
alias j61="jswitch '-\\(61[^0-9]\\|1\\.61\\)'" # 2043-09
alias j62="jswitch '-\\(62[^0-9]\\|1\\.62\\)'" # 2044-03
alias j63="jswitch '-\\(63[^0-9]\\|1\\.63\\)'" # 2044-09
alias j64="jswitch '-\\(64[^0-9]\\|1\\.64\\)'" # 2045-03
# 2045-05: Curtis turns 65 and retires ;_;
alias j8fx='jswitch fx-jdk8'
alias j8z='jswitch zulu-8'
alias j11z='jswitch zulu-11'
alias j17z='jswitch zulu-17'

# use OpenJDK 8 by default, ideally with JavaFX, if available
export J8=$(jhome fx-8)
test "$J8" || export J8=$(jhome '-\(8[^0-9]\|1\.8\)')
test "$J8" && export JAVA_HOME="$J8"

# add aliases for launching Java
alias j='java'
alias jc='javac'
alias jp='javap'
