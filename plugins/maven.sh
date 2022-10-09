test "$DEBUG" && echo "[dotfiles] Loading plugin 'maven'..."

export MAVEN_OPTS="-Xmx1536m"

# license-maven-plugin
lic() {
	local quiet=
	test "$1" = "-q" && quiet=true
	test -f pom.xml || {
		test -z "$quiet" && echo "[ERROR] Not a Maven project."
		return 1
	}
	local licName=$(grep 'license\.licenseName' pom.xml | sed -e 's/[^>]*>//' -e 's/<.*//')
	test "$licName" -a "$licName" != "N/A" || {
		test -z "$quiet" && echo "[ERROR] Unsupported license: $licName"
		return 2
	}
	mvn license:update-file-header license:update-project-license
}

# dependency-maven-plugin
alias anal='mvn dependency:analyze | grep WARNING'

# tidy-maven-plugin
alias tdy='mvn tidy:pom'

# build it!
alias b='lic -q; mvn clean install'
alias bs='mvn -DskipTests -Denforcer.skip -Dinvoker.skip clean install'
