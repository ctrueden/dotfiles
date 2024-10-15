#!/bin/sh

OLD=/tmp/mvn-deps-old.txt
NEW=/tmp/mvn-deps-new.txt

head=$(cat .git/HEAD)
head=${head##*/}

mvn -B dependency:list |sort > $NEW
git checkout HEAD^ >/dev/null
mvn -B dependency:list |sort > $OLD
git checkout "$head" >/dev/null
git diff $OLD $NEW |
  grep '^[-+].*:.*:.*:.*' |
  grep -v 'Finished at' |
  sed 's/^\(.\)\[INFO\]\s*/\1/'

rm $OLD $NEW
