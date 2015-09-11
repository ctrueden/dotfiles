#!/bin/sh

# using.sh - A script to remind me how to do stuff in sh.

# In particular, I constantly forget how to use the asterisk (*)
# and hash (#) in variable substitution for substrings.
# THE LINE MUST BE DRAWN HERE. THIS FAR AND NO FURTHER.

# Thanks to: http://mywiki.wooledge.org/BashFAQ/073

echo
echo "-- String manipulation --"

name='polish.ostrich.racing.champion'
echo
echo "\$name             = '$name'"             # polish.ostrich.racing.champion
echo "\${name#*.}        = '${name#*.}'"        #        ostrich.racing.champion
echo "\${name##*.}       = '${name##*.}'"       #                       champion
echo "\${name%%.*}       = '${name%%.*}'"       # polish
echo "\${name%.*}        = '${name%.*}'"        # polish.ostrich.racing
echo
echo "\${name:16}        = '${name:16}'"        #                 acing.champion
echo "\${name: -7}       = '${name: -7}'"       #                        hampion
echo "\${name:0:5}       = '${name:0:5}'"       # polis
echo "\${name:8:3}       = '${name:8:3}'"       #         str

file='/usr/share/java-1.4.2-sun/demo/applets/Clock/Clock.class'
echo
echo "\$file             = '$file'"             # /usr/share/java-1.4.2-sun/demo/applets/Clock/Clock.class
echo "\${file#*/}        = '${file#*/}'"        #  usr/share/java-1.4.2-sun/demo/applets/Clock/Clock.class
echo "\${file##*/}       = '${file##*/}'"       #                                              Clock.class
echo "\${file%%/*}       = '${file%%/*}'"       #
echo "\${file%/*}        = '${file%/*}'"        # /usr/share/java-1.4.2-sun/demo/applets/Clock

phrase='The quick brown fox is quicker than the dog.'
echo
echo "\$phrase           = '$phrase'"           # The quick brown fox is quicker than the dog.
echo "\${phrase#*quick}  = '${phrase#*quick}'"  #           brown fox is quicker than the dog.
echo "\${phrase%quick*}  = '${phrase%quick*}'"  # The quick brown fox is 
echo "\${phrase##*quick} = '${phrase##*quick}'" #                             er than the dog.
echo "\${phrase%%quick*} = '${phrase%%quick*}'" # The 

echo
echo "-- Other hints --"

echo
echo "For multi-line replace, use perl!"
echo 'perl -0777 -i -pe "s/the first line\\nthe second line\\n//igs" <files-to-match>'
