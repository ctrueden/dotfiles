#!/bin/sh

set -e
#set -x

confirm() {
	test "z$2" != "z" && echo "$1 = $2" || die "No $1 found."
}

die() {
	echo "[ERROR] $*"
	return 1
}

addBlock() {
	grep -q "^	<$1>" pom.xml ||
		perl -0777 -i -pe "s\$(</modelVersion>)\$\1\n\t<$1>$2</$1>\$is" pom.xml
}

addProp() {
	grep -q "^	<$1>" pom.xml ||
		perl -0777 -i -pe "s\$(<properties>\n)\$\1\t\t<$1>$2</$1>\n\$is" pom.xml
}

# -- sanity checks --

org=$(basename $(dirname $(pwd)))
component=$(basename $(pwd))
echo
echo "[$org/$component]"

# make sure project has a parent
grep -q '^	<parent>$' pom.xml || die "No <parent> element."

# extract parent POM
parent=$(grep '^		<artifactId>' pom.xml | sed 's/.*<artifactId>\(.*\)<\/artifactId>/\1/')
confirm parent.artifactId "$parent"

# make sure parent POM is a supported one
echo "$parent" | grep -q '^\(pom-scijava\|pom-imagej\|pom-fiji\|pom-scifio\)$' ||
	die "Unsupported parent POM: $parent"

# extract parent version
pomVer=$(grep '^		<version>' pom.xml | head -n1 | sed 's/.*<version>\(.*\)<\/version>/\1/')
confirm parent.version "$pomVer"

# check whether we still need to upgrade
test "z$parent" = "zpom-scijava" -a "z$pomVer" = "z12.0.0" &&
	die "Parent POM already upgraded."

# make sure project has Java sources
git ls-files \*.java | grep -q . || die "No Java source files."

# make sure license header is already there
cat $(git ls-files \*.java | head -n1) | head -n2 | grep -q '^ \* #%L' ||
	die "Missing license header on first source file."

# -- discern the metadata --

# discern the groupId
groupId=$(grep '^		<groupId>' pom.xml | sed 's/.*<groupId>\(.*\)<\/groupId>/\1/')
confirm project.groupId "$groupId"

# discern the project name
name=$(grep '^	<name>' pom.xml | head -n1 | sed 's/^.*<name>\(.*\)<\/name>$/\1/')
confirm project.name "$name"

# discern the URL, organization and mailing lists
url=$(grep '^	<url>' pom.xml | head -n1 | sed 's/^.*<url>\(.*\)<\/url>$/\1/')
wikiPage=$(echo "$name" | sed 's/[: ][: ]*/_/g')
confirm wiki-page "$wikiPage"
case "$parent" in
	pom-scijava)
		test "z$url" = "z" && url="http://scijava.org/"
		orgName="SciJava"
		orgURL="http://scijava.org/"
		mailName="SciJava"
		mailSub="https://groups.google.com/group/scijava"
		mailPost="scijava@googlegroups.com"
		mailArchive="https://groups.google.com/group/scijava"
		;;
	pom-imagej)
		test "z$url" = "z" && url="http://imagej.net/$wikiPage"
		orgName="ImageJ"
		orgURL="http://imagej.net/"
		mailName="ImageJ Forum"
		mailSub=""
		mailPost=""
		mailArchive="http://forum.imagej.net/"
		;;
	pom-fiji)
		test "z$url" = "z" && url="http://imagej.net/$wikiPage"
		orgName="Fiji"
		orgURL="http://fiji.sc/"
		mailName="ImageJ Forum"
		mailSub=""
		mailPost=""
		mailArchive="http://forum.imagej.net/"
		;;
	pom-scifio)
		test "z$url" = "z" && url="http://imagej.net/$wikiPage"
		orgName="SCIFIO"
		orgURL="http://scif.io/"
		mailName="ImageJ Forum"
		mailSub=""
		mailPost=""
		mailArchive="http://forum.imagej.net/"
		;;
	*)
		die "Unknown parent: $parent"
		;;
esac
confirm project.url "$url"
confirm organization.name "$orgName"
confirm organization.url "$orgURL"
confirm 'mailingLists[0].name' "$mailName"
confirm 'mailingLists[0].archive' "$mailArchive"

# discern the inception year
#year=$(git show -s --format=%cI $(git rev-list --max-parents=0 master) | cut -d '-' -f 1)
year=$(cat $(git ls-files \*.java | head -n1) | head -n5 | tail -n1 | grep 'Copyright' | sed 's/^ \* Copyright (C) \([0-9]\{4\}\).*/\1/')
confirm project.inceptionYear "$year"

# discern the license
cat $(git ls-files \*.java | head -n1) |
	grep -A 1 'under the terms of the GNU General Public License' |
	grep -q 'version 2' &&
		licName=gpl_v2 &&
		lName="GNU General Public License v2+" &&
		lURL="http://www.gnu.org/licenses/gpl.html"
cat $(git ls-files \*.java | head -n1) |
	grep -A 1 'under the terms of the GNU General Public License' |
	grep -q 'version 3' &&
		licName=gpl_v3 &&
		lName="GNU General Public License v3+" &&
		lURL="http://www.gnu.org/licenses/gpl.html"
cat $(git ls-files \*.java | head -n1) |
	grep -A 15 'Redistribution and use in source and binary forms' |
	grep -q '^ \* 2. ' &&
		licName=bsd_2 &&
		lName="Simplified BSD License" &&
		lURL=""
cat $(git ls-files \*.java | head -n1) |
	grep -A 15 'Redistribution and use in source and binary forms' |
	grep -q '^ \* 3. ' &&
		lName="Simplified BSD License" &&
		lURL=""
cat $(git ls-files \*.java | head -n1) |
	grep -q 'Licensed under the Apache License, Version 2.0' &&
		licName=apache_v2 &&
		lName="Apache Software License, Version 2.0" &&
    lURL="http://www.apache.org/licenses/LICENSE-2.0.txt"
cat $(git ls-files \*.java | head -n1) |
	grep -q 'To the extent possible under law, .* have waived' &&
		licName=cc0 &&
		lName="CC0 1.0 Universal License" &&
    lURL="http://creativecommons.org/publicdomain/zero/1.0/"
cat $(git ls-files \*.java | head -n1) |
	grep -q "You'll be free to use this software for research purposes" &&
		licName=big &&
		lName="BIG" &&
    lURL="http://imagej.net/BIG_License"
confirm license.licenseName "$licName"

licOwners=$(cat $(git ls-files \*.java | head -n1) | head -n11 | tail -n7 | grep -v '^ \* %%' | grep -v '^ \* *$' | grep -v '^ \* \(Redistribution\|modification\|This program\|it under\)' | sed 's/Copyright .* [0-9]\{4\} //' | sed 's/^ \* //')
confirm license.copyrightOwners "$licOwners"

licProj=$(cat $(git ls-files \*.java | head -n1) | head -n3 | tail -n1 | sed 's/^ \* //')
confirm license.projectName "$licProj"

# discern the description
desc=$(grep '^	<description>' pom.xml | sed 's/.*<description>\(.*\)<\/description>/\1/')
confirm project.description "$desc"

# guess at the package name
# use the shortest directory prefix
pkg=$(
	for f in $(git ls-files | grep '^src/main/java/.*\.java')
	do
		d=$(dirname "$f")
		echo "${d##*src/main/java/}"
	done |
		sort -u | awk '{ print length, $0 }' |
		sort -ns | head -n1 | cut -d ' ' -f 2 | sed 's/\//./g'
)
confirm package-name "$pkg"

# -- update the POM --

# replace parent with org.scijava:pom-scijava:12.0.0
sed -i '' -e 's/^		<groupId>.*/		<groupId>org.scijava<\/groupId>/' pom.xml
sed -i '' -e 's/^		<artifactId>.*/		<artifactId>pom-scijava<\/artifactId>/' pom.xml
sed -i '' -e 's/^		<version>.*/		<version>12.0.0<\/version>/' pom.xml

# inject groupId if missing
test "$parent" = "org.scijava" || addBlock groupId "$groupId"

# add <properties> if not already present
addBlock properties "\n\t"

# add <licenses> if not already present
test "z$lURL" = "z" &&
	addBlock licenses "\n\t\t<license>\n\t\t\t<name>$lName</name>\n\t\t\t<distribution>repo</distribution>\n\t\t</license>\n\t" ||
	addBlock licenses "\n\t\t<license>\n\t\t\t<name>$lName</name>\n\t\t\t<url>$lURL</url>\n\t\t\t<distribution>repo</distribution>\n\t\t</license>\n\t"

# add <url> if not already present
addBlock url "$url"

# add <inceptionYear> if not already present
addBlock inceptionYear "$year"

# add <organization> if not already present
addBlock organization "\n\t\t<name>$orgName<\/name>\n\t\t<url>$orgURL<\/url>\n\t"

# add <mailingLists> if not already present
test "z$mailSub" = "z" &&
	addBlock mailingLists "\n\t\t<mailingList>\n\t\t\t<name>$mailName</name>\n\t\t\t<archive>$mailArchive</archive>\n\t\t</mailingList>\n\t" ||
	addBlock mailingLists "\n\t\t<mailingList>\n\t\t\t<name>$mailName</name>\n\t\t\t<subscribe>$mailSub</subscribe>\n\t\t\t<unsubscribe>$mailSub</unsubscribe>\n\t\t\t<post>$mailPost</post>\n\t\t\t<archive>$mailArchive</archive>\n\t\t</mailingList>\n\t"

# prepend license-maven-plugin properties
test "z$desc" = "z$licProj" ||
	addProp license.projectName "$licProj"
addProp license.copyrightOwners "$licOwners"
addProp license.licenseName "$licName"

# prepend package name if detected
test "z$pkg" = "z" || addProp package-name "$pkg"

# strip scijava.jvm.version 1.8 if present
sed -i '' -e '/<scijava.jvm.version>1.8<\/scijava.jvm.version>/d' pom.xml

# format the pom
mvn tidy:pom

# try to build!
mvn clean package

# it worked; commit it
git commit -F ~/msgs/unify-poms.txt pom.xml

# update license headers as needed
mvn license:update-file-header license:update-project-license
git add LICENSE.txt
git commit -a -m 'Happy New Year 2016'
