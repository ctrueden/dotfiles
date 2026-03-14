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

_jinfo() {
  : << 'DOC'
Emit a tab-separated version+path line for the given JDK directory,
if it contains a java executable and a readable release file.
DOC
  local d="$1" ver
  [ -x "$d/bin/java" ] || [ -x "$d/bin/java.exe" ] || return
  ver=$(jver "$d")
  [ "$ver" ] && printf '%s\t%s\n' "$ver" "$d"
}

jver() {
  : << 'DOC'
Extract the version from the release file of the given JDK dir.
For standard JDKs, returns the JAVA_VERSION value (e.g. 21.0.10).
For GraalVM, returns graalvm-JAVA_VERSION (e.g. graalvm-17.0.6).
DOC
  local release="$1/release" java_ver
  java_ver=$(grep '^JAVA_VERSION=' "$release" 2>/dev/null | sed 's/^JAVA_VERSION="\(.*\)"$/\1/')
  [ "$java_ver" ] || return
  if grep -q '^GRAALVM_VERSION=' "$release" 2>/dev/null
  then
    printf 'graalvm-%s\n' "$java_ver"
  else
    echo "$java_ver"
  fi
}

jlist() {
  : << 'DOC'
List the available Java installations, for both the user and system-wide.
Emits two tab-separated columns: version number and absolute path.
Installations are discovered beneath ~/Java, the cjdk cache, macOS java_home,
Linux update-java-alternatives, and Homebrew. An optional filter pattern
is matched against the version column (first column) only.
DOC
  {
    # Java installations in ~/Java.
    if [ -d "$HOME/Java" ]
    then
      find "$HOME/Java" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r d
      do
        if [ -x "$d/Contents/Home/bin/java" ]
        then
          _jinfo "$d/Contents/Home"
        else
          _jinfo "$d"
        fi
      done
    fi

    # Java installations from cjdk cache.
    local cjdk_cache=
    if [ -d "$HOME/Library/Caches/cjdk" ]
    then
      cjdk_cache="$HOME/Library/Caches/cjdk"
    elif [ -d "${XDG_CACHE_HOME:-$HOME/.cache}/cjdk" ]
    then
      cjdk_cache="${XDG_CACHE_HOME:-$HOME/.cache}/cjdk"
    fi
    if [ -n "$cjdk_cache" ]
    then
      find -L "$cjdk_cache" -mindepth 6 -maxdepth 8 -name java -path "*/bin/java" 2>/dev/null | while IFS= read -r j
      do
        _jinfo "$(dirname "$(dirname "$j")")"
      done
    fi

    # Java installations from java_home (macOS).
    if [ -x /usr/libexec/java_home ]
    then
      /usr/libexec/java_home -V 2>&1 | grep ' jdk' | sed 's/.* //' | while IFS= read -r d
      do
        _jinfo "$d"
      done
    fi

    # Java installations from update-java-alternatives (Linux).
    if [ -x /usr/sbin/update-java-alternatives ]
    then
      /usr/sbin/update-java-alternatives -l | sed 's/.* //' | while IFS= read -r d
      do
        _jinfo "$d"
      done
    fi

    # Java installations from Homebrew.
    for prefix in /opt/homebrew/Cellar/openjdk /usr/local/Cellar/openjdk
    do
      test -d "$prefix" || continue
      find "$prefix" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r d
      do
        _jinfo "$d"
      done
    done
  } | sort -u | if [ $# -gt 0 ]; then awk -v pat="$*" '$1 ~ pat'; else cat; fi
}

jhome() {
  : << 'DOC'
Report the path of the first Java installation matching the given pattern,
or the current value of JAVA_HOME if no arguments are given. The pattern
is matched against the version column of jlist output.
DOC
  if [ $# -eq 0 ]
  then
    echo "$JAVA_HOME"
  else
    jlist "$@" | head -n1 | cut -f2
  fi
}

jswitch() {
  : << 'DOC'
Switch the current shell's active Java installation to one matching
the given pattern. If no local installation matches and cjdk is available,
the argument is passed directly to cjdk as a vendor:version spec for
download-on-demand (e.g. jswitch zulu:21).
DOC
  local result
  result=$(jhome "$@")
  if [ -z "$result" ] && command -v cjdk >/dev/null 2>&1
  then
    result=$(cjdk --jdk "$*" java-home 2>/dev/null)
  fi
  test "$result" || {
    >&2 echo "No matching Java for arguments: $@"
    return 1
  }
  export JAVA_HOME="$result" &&
    echo "JAVA_HOME -> $JAVA_HOME" &&
    jexec java -version
}

jgswitch() {
  : << 'DOC'
Switch the current shell's active Java to a GraalVM installation matching
the given Java major version number (e.g. jgswitch 21). Checks the local
cache first; if not found, downloads via cjdk using graalvm-java<N>.
With no argument, switches to any available GraalVM installation.
DOC
  local n="$1" result
  if [ -n "$n" ]
  then
    result=$(jhome "^graalvm-${n}\.")
  else
    result=$(jhome "^graalvm-")
  fi
  if [ -z "$result" ] && command -v cjdk >/dev/null 2>&1
  then
    result=$(cjdk --jdk "graalvm-java${n:-21}" java-home 2>/dev/null)
  fi
  test "$result" || {
    >&2 echo "No GraalVM Java ${n:-*} found"
    return 1
  }
  export JAVA_HOME="$result" &&
    echo "JAVA_HOME -> $JAVA_HOME" &&
    jexec java -version
}

alias jg11='jgswitch 11'  # GraalVM for Java 11
alias jg16='jgswitch 16'  # GraalVM for Java 16
alias jg17='jgswitch 17'  # GraalVM for Java 17
alias jg19='jgswitch 19'  # GraalVM for Java 19
alias jg20='jgswitch 20'  # GraalVM for Java 20
alias jg21='jgswitch 21'  # GraalVM for Java 21
alias jg22='jgswitch 22'  # GraalVM for Java 22
alias jg23='jgswitch 23'  # GraalVM for Java 23
alias jg24='jgswitch 24'  # GraalVM for Java 24
alias jg25='jgswitch 25'  # GraalVM for Java 25

alias j0='jswitch "^1\.0\."'  # 1996-01-23
alias j1='jswitch "^1\.1\."'  # 1997-02-02
alias j2='jswitch "^1\.2\."'  # 1998-12-04
alias j3='jswitch "^1\.3\."'  # 2000-05-08
alias j4='jswitch "^1\.4\."'  # 2002-02-13
alias j5='jswitch "^1\.5\."'  # 2004-09-29 (Tiger)
alias j6='jswitch "^1\.6\."'  # 2006-12-11 (Mustang)
alias j7='jswitch "^1\.7\."'  # 2011-07-28 (Dolphin)
alias j8='jswitch "^1\.8\."'  # 2014-03-18 (Spider)
alias j9='jswitch "^9\."'     # 2017-09-21
alias j10='jswitch "^10\."'   # 2018-03-20
alias j11='jswitch "^11\."'   # 2018-09-25
alias j12='jswitch "^12\."'   # 2019-03-19
alias j13='jswitch "^13\."'   # 2019-09-17
alias j14='jswitch "^14\."'   # 2020-03-17
alias j15='jswitch "^15\."'   # 2020-09-15
alias j16='jswitch "^16\."'   # 2021-03-16
alias j17='jswitch "^17\."'   # 2021-09-14
alias j18='jswitch "^18\."'   # 2022-03-22
alias j19='jswitch "^19\."'   # 2022-09-20
alias j20='jswitch "^20\."'   # 2023-03-21
alias j21='jswitch "^21\."'   # 2023-09
alias j22='jswitch "^22\."'   # 2024-03
alias j23='jswitch "^23\."'   # 2024-09
alias j24='jswitch "^24\."'   # 2025-03
alias j25='jswitch "^25\."'   # 2025-09
alias j26='jswitch "^26\."'   # 2026-03
alias j27='jswitch "^27\."'   # 2026-09
alias j28='jswitch "^28\."'   # 2027-03
alias j29='jswitch "^29\."'   # 2027-09
alias j30='jswitch "^30\."'   # 2028-03
alias j31='jswitch "^31\."'   # 2028-09
alias j32='jswitch "^32\."'   # 2029-03
alias j33='jswitch "^33\."'   # 2029-09
alias j34='jswitch "^34\."'   # 2030-03
alias j35='jswitch "^35\."'   # 2030-09
alias j36='jswitch "^36\."'   # 2031-03
alias j37='jswitch "^37\."'   # 2031-09
alias j38='jswitch "^38\."'   # 2032-03
alias j39='jswitch "^39\."'   # 2032-09
alias j40='jswitch "^40\."'   # 2033-03
alias j41='jswitch "^41\."'   # 2033-09
alias j42='jswitch "^42\."'   # 2034-03
alias j43='jswitch "^43\."'   # 2034-09
alias j44='jswitch "^44\."'   # 2035-03
alias j45='jswitch "^45\."'   # 2035-09
alias j46='jswitch "^46\."'   # 2036-03
alias j47='jswitch "^47\."'   # 2036-09
alias j48='jswitch "^48\."'   # 2037-03
alias j49='jswitch "^49\."'   # 2037-09
alias j50='jswitch "^50\."'   # 2038-03
alias j51='jswitch "^51\."'   # 2038-09
alias j52='jswitch "^52\."'   # 2039-03
alias j53='jswitch "^53\."'   # 2039-09
alias j54='jswitch "^54\."'   # 2040-03
alias j55='jswitch "^55\."'   # 2040-09
alias j56='jswitch "^56\."'   # 2041-03
alias j57='jswitch "^57\."'   # 2041-09
alias j58='jswitch "^58\."'   # 2042-03
alias j59='jswitch "^59\."'   # 2042-09
alias j60='jswitch "^60\."'   # 2043-03
alias j61='jswitch "^61\."'   # 2043-09
alias j62='jswitch "^62\."'   # 2044-03
alias j63='jswitch "^63\."'   # 2044-09
alias j64='jswitch "^64\."'   # 2045-03
# 2045-05: Curtis turns 65 and retires ;_;

# use OpenJDK 8 by default if available
export J8=$(jhome "^1\.8\.")
test "$J8" && export JAVA_HOME="$J8"

# add aliases for launching Java
alias j='java'
alias jc='javac'
alias jp='javap'
