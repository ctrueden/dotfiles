# set locations of Java
if [ -x /usr/libexec/java_home ]; then
	# macOS
	jhome() {
		/usr/libexec/java_home -v "$@" 2>/dev/null
	}
elif [ -x /usr/sbin/update-java-alternatives ]; then
	# Linux
	jhome() {
		/usr/sbin/update-java-alternatives -l | grep "$@" | head -n 1 | cut -f 3 -d ' '
	}
else
	jhome() { :; }
fi
export J6="$(jhome '1.6')"
export J7="$(jhome '1.7')"
export J8="$(jhome '1.8')"
export J9="$(jhome '9')"
export J10="$(jhome '10')"
export J11="$(jhome '11')"
export J12="$(jhome '12')"
export J13="$(jhome '13')"
export J14="$(jhome '14')"
export J15="$(jhome '15')"
export J16="$(jhome '16')"
export J17="$(jhome '17')"
export J18="$(jhome '18')"
export J19="$(jhome '19')"
test -n "$J6" || export J6="$(jhome '6-oracle')"
test -n "$J7" || export J7="$(jhome '7-oracle')"
test -n "$J8" || export J8="$(jhome '8-oracle')"
test -n "$J9" || export J9="$(jhome '9-oracle')"
test -n "$J10" || export J10="$(jhome '10-oracle')"
test -n "$J11" || export J11="$(jhome '11-oracle')"
test -n "$J12" || export J12="$(jhome '12-oracle')"
test -n "$J13" || export J13="$(jhome '13-oracle')"
test -n "$J14" || export J14="$(jhome '14-oracle')"
test -n "$J15" || export J15="$(jhome '15-oracle')"
test -n "$J16" || export J16="$(jhome '16-oracle')"
test -n "$J17" || export J17="$(jhome '17-oracle')"
test -n "$J18" || export J18="$(jhome '18-oracle')"
test -n "$J19" || export J19="$(jhome '19-oracle')"
alias j6='export JAVA_HOME="$J6" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j7='export JAVA_HOME="$J7" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j8='export JAVA_HOME="$J8" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j9='export JAVA_HOME="$J9" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j10='export JAVA_HOME="$J10" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j11='export JAVA_HOME="$J11" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j12='export JAVA_HOME="$J12" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j13='export JAVA_HOME="$J13" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j14='export JAVA_HOME="$J14" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j15='export JAVA_HOME="$J15" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j16='export JAVA_HOME="$J16" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j17='export JAVA_HOME="$J17" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j18='export JAVA_HOME="$J18" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j19='export JAVA_HOME="$J19" && echo "JAVA_HOME -> $JAVA_HOME" && java -version'

# use Java 8 by default if available
test -n "$J8" && export JAVA_HOME="$J8"

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
