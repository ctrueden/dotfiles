export MAVEN_OPTS="-Xmx1536m"

# launch Maven 2.x with 'mvn2'
if [ -d "$BREW/Cellar/maven2" ]; then
	alias mvn2="$BREW/Cellar/maven2/2.2.1/bin/mvn"
fi

# license-maven-plugin
alias lic='mvn license:update-project-license license:update-file-header'

# dependency-maven-plugin
alias anal='mvn dependency:analyze | grep WARNING'

# build it!
alias b='mvn clean install'
alias bs='mvn -DskipTests -Denforcer.skip clean install'
