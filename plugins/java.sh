test "$DEBUG" && echo "[dotfiles] Loading plugin 'java'..."

# Define the java command to use the java executable from JAVA_HOME.
# - On macOS, this already happens indirectly.
# - On Linux, /bin/java and /usr/bin/java point at /etc/alternatives/java,
#   which is controlled system-wide by update-java-alternatives.
unset -f java 2>/dev/null
export SYSTEM_JAVA_BIN=$(dirname "$(command -v java)")

jexec() {
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
java() { jexec java $@; }
javac() { jexec javac $@; }
javah() { jexec javah $@; }
javap() { jexec javap $@; }
javadoc() { jexec javadoc $@; }
jshell() { jexec jshell $@; }

# set locations of Java
if [ -x /usr/libexec/java_home ]
then
	# macOS
	jhome() {
		/usr/libexec/java_home -v "$@" 2>/dev/null
	}
elif [ -x /usr/sbin/update-java-alternatives ]
then
	# Linux
	jhome() {
		/usr/sbin/update-java-alternatives -l | grep "$@" | head -n 1 | sed 's/.* //'
	}
else
	jhome() { :; }
fi
jswitch() {
	export JAVA_HOME="$(jhome $@)" &&
		echo "JAVA_HOME -> $JAVA_HOME" &&
		java -version
}
alias j6='jswitch 1.6'
alias j7='jswitch 1.7'
alias j8='jswitch 1.8'
alias j9='jswitch 9'
alias j10='jswitch 10'
alias j11='jswitch 11'
alias j12='jswitch 12'
alias j13='jswitch 13'
alias j14='jswitch 14'
alias j15='jswitch 15'
alias j16='jswitch 16'
alias j17='jswitch 17'
alias j18='jswitch 18'
alias j19='jswitch 19'
alias j20='jswitch 20'
alias j21='jswitch 21'
alias j22='jswitch 22'
alias j23='jswitch 23'
alias j24='jswitch 24'
alias j25='jswitch 25'
alias j26='jswitch 26'
alias j27='jswitch 27'
alias j28='jswitch 28'
alias j29='jswitch 29'
alias j30='jswitch 30'
alias j31='jswitch 31'
# 32 versions of Java ought to be enough for anybody.
alias j8z='jswitch zulu8'
alias j11z='jswitch zulu11'
alias j17z='jswitch zulu17'

# use Java 8 by default if available
J8=$(jhome 1.8) test -n "$J8" && export JAVA_HOME="$J8"

# add aliases for launching Java
alias j='java'
alias jc='javac'
alias jp='javap'
