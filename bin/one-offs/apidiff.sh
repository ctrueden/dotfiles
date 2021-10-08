#!/bin/sh

# TODO: Why doesn't this work
trap "exit" INT

die() {
  echo "$1" 2>&1
  exit 1
}

dumpAPI() {
  jar="$1"
  jar tf "$jar" |
    grep '\.class$' |     # only process classes
    grep -v '\$' |        # filter out inner classes
    sed 's/\.class$//' |  # remove .class suffix
    sed 's_/_._g' |       # change path -> package separators
    sort |                # process in consistent order
    while read p
  do
    javap -cp "$jar" "$p"
  done
}

jar1="$1"
jar2="$2"
test -f "$jar1" -a -f "$jar2" || die "Please specify two JAR files."
out1=$(mktemp)
out2=$(mktemp)
dumpAPI "$jar1" > "$out1"
dumpAPI "$jar2" > "$out2"

# NB: Or replace with your favorite diff tool.
git diff --no-index "$out1" "$out2"

# Clean up.
rm -f "$out1" "$out2"
