test "$DEBUG" && echo "[dotfiles] Loading plugin $(basename "$0")..."

export MAVEN_OPTS="-Xmx1536m"

# launch Maven 2.x with 'mvn2'
if [ -d "$BREW/Cellar/maven2" ]; then
	alias mvn2="$BREW/Cellar/maven2/2.2.1/bin/mvn"
fi

# license-maven-plugin
alias lic='mvn license:update-project-license license:update-file-header'

# dependency-maven-plugin
alias anal='mvn dependency:analyze | grep WARNING'

# tidy-maven-plugin
alias tdy='mvn tidy:pom'

# build it!
alias b='mvn clean install'
alias bs='mvn -DskipTests -Denforcer.skip -Dinvoker.skip clean install'
