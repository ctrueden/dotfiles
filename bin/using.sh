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
echo "\${#name}          = ${#name}"            # 30
echo
echo "\${name#*.}        = '${name#*.}'"        #        ostrich.racing.champion
echo "\${name##*.}       = '${name##*.}'"       #                       champion
echo "\${name%%.*}       = '${name%%.*}'"       # polish
echo "\${name%.*}        = '${name%.*}'"        # polish.ostrich.racing
#echo
#echo "\${name:16}        = '${name:16}'"        #                 acing.champion
#echo "\${name: -7}       = '${name: -7}'"       #                        hampion
#echo "\${name:0:5}       = '${name:0:5}'"       # polis
#echo "\${name:8:3}       = '${name:8:3}'"       #         str
#echo "WARNING: THE ABOVE INDEX-BASED NOTATION IS PROBABLY NOT PORTABLE."

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

#echo
#echo "-- Indirection --"
#
#var='name'
#echo
#echo "\$var              = $var"                # name
#echo "\${!var}           = ${!var}"             # polish.ostrich.racing.champion
#echo "WARNING: APPARENTLY THIS SYNTAX IS NOT PORTABLE; zsh 5.4.2 (x86_64-ubuntu-linux-gpu) CANNOT HANDLE IT."

echo
echo "-- Files with spaces --"

echo
echo 'find . -name '*foo*' -print0 | while read -d $'\''\\0'\'' f'
echo 'do'
echo '  ls -dl "$f"'
echo 'done'

echo
echo 'git ls-files -z | while read -d $'\''\\0'\'' f'
echo 'do'
echo '  test -f "$f" || echo "NOT A REGULAR FILE: $f"'
echo 'done'

echo
echo '-- Multi-line replace --'

echo
echo 'For multi-line replace, use perl!'
echo 'perl -0777 -i -pe "s/the first line\\nthe second line\\n//igs" <files-to-match>'

echo
echo '-- Syntax checking --'
# Credit: https://news.ycombinator.com/item?id=11190623

echo
echo 'Check syntax:'
echo 'sh -n myscript'
echo
echo 'Check for bash-specific syntax:'
echo 'checkbashisms myscript'
echo
echo 'Check for various gotchas:'
echo 'shellcheck myscript'
echo
echo 'Check for style:'
echo 'bashate myscript'
echo
echo 'Check for badness:'
echo "grep -rE '(wget|curl).\|( sudo)? *(ba|z|)sh' myscript"
