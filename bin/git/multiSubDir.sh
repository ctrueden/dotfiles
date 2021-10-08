#!/bin/sh

# This script uses "git filter-branch --tree-filter" to simulate a
# "git filter-branch --subdirectory-filter" with multiple directories at once.
#
# The directories given as arguments will all be merged to the root directory,
# in order from first to last argument (meaning the later arguments given will
# overwrite the earlier ones in case of any overlapping files).

if [ -z "$1" ]
then
  echo "Usage: git filter-branch -f --prune-empty --tree-filter 'sh multiSubDir.sh dir1 dir2 ...'"
  echo
  exit 1
fi

# look for matching directories
for dir in $@
do
  if [ -d "$dir" ]
  then
    mkdir -p .final
    cp -r "$dir/"* .final/
  fi
done

# clear out non-matching paths
rm -rf * .[a-eh-zA-Z0-9_]*
if [ -d .final ]; then mv .final .z_final; fi
if [ -d .git ]; then mv .git .z_git; fi
rm -rf .f* .g*
if [ -d .z_final ]; then mv .z_final .final; fi
if [ -d .z_git ]; then mv .z_git .git; fi

# move matching stuff back to root
if [ -d .final ]
then
  if [ "$(ls .final | wc -l)" -gt 0 ]
  then
    mv .final/* .
  fi
fi

# clean up
rm -rf .final
