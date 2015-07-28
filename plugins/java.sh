# set locations of Java
if [ -x /usr/libexec/java_home ]; then
	# OS X
	jhome() {
		/usr/libexec/java_home -v "$@"
	}
	jswitch() { :; }
elif [ -x /usr/sbin/update-java-alternatives ]; then
	# Linux
	jhome() {
		/usr/sbin/update-java-alternatives -l | grep "$@" | head -n 1 | cut -f 3 -d ' '
	}
	jswitch() {
		sudo update-java-alternatives --set "${JAVA_HOME##*/}"
	}
else
	jhome() { :; }
	jswitch() { :; }
fi
export J6="$(jhome '1.6')"
export J7="$(jhome '1.7')"
export J8="$(jhome '1.8')"
test -n "$J6" || export J6="$(jhome '6-oracle')"
test -n "$J7" || export J7="$(jhome '7-oracle')"
test -n "$J8" || export J8="$(jhome '8-oracle')"
alias j6='export JAVA_HOME="$J6" && jswitch && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j7='export JAVA_HOME="$J7" && jswitch && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j8='export JAVA_HOME="$J8" && jswitch && echo "JAVA_HOME -> $JAVA_HOME" && java -version'

# unset the actual classpath, since some programs play badly with it
unset CLASSPATH

# add some basic directories to the classpath
# NB: We avoid the CLASSPATH variable since some programs play badly with it.
export JAVA_CP=\
$HOME/java:\
$CODE_PRIVATE/java:\
$CODE_PRIVATE/java/utils

# generate classpath for desired Maven artifacts
cpFile="$HOME/.java-classpath"
if [ ! -e "$cpFile" ]; then
	# generate classpath cache
	echo "Regenerating $cpFile"
	maven-cp \
		ome:formats-gpl:5.0.5 \
		loci:loci-utils:1.0.0-SNAPSHOT \
		org.beanshell:bsh:2.0b4 > $cpFile
fi
export JAVA_CP="$JAVA_CP:$(cat $cpFile)"

# add aliases for launching Java with the JAVA_CP classpath
alias j='java -cp "$JAVA_CP:."'
alias jc='javac -cp "$JAVA_CP:."'
alias jp='javap -cp "$JAVA_CP:."'
