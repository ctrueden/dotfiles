#!/bin/sh

# using.sh - A script to remind me about shell scripting constructs.

# Thanks to: https://mywiki.wooledge.org/BashFAQ/073

echo
echo '-- Substrings --'

# Note: The following tricks are part of the
# POSIX shell parameter expansion specification.

name='polish.ostrich.racing.champion'
echo
echo '$name                        '"= '$name'"                      # polish.ostrich.racing.champion
echo '${#name}                     '"= ${#name}"                     # 30
echo '${name#*.}                   '"= '${name#*.}'"                 #        ostrich.racing.champion
echo '${name##*.}                  '"= '${name##*.}'"                #                       champion
echo '${name%%.*}                  '"= '${name%%.*}'"                # polish
echo '${name%.*}                   '"= '${name%.*}'"                 # polish.ostrich.racing
echo '$(expr substr "$name" 17 13) '"= $(expr substr "$name" 17 13)" #                 acing.champion
echo '$(expr substr "$name" 1 5)   '"= $(expr substr "$name" 1 5)"   # polis
echo '$(expr substr "$name" 9 3)   '"= $(expr substr "$name" 9 3)"   #         str
# Note: The following index-based substring notation is not
# POSIX-compliant. In particular, it does not work in dash.
#echo
#echo '${name:16}                   '"= '${name:16}'"                 #                 acing.champion
#echo '${name: -7}                  '"= '${name: -7}'"                #                        hampion
#echo '${name:0:5}                  '"= '${name:0:5}'"                # polis
#echo '${name:8:3}                  '"= '${name:8:3}'"                #         str

file='/usr/share/java-1.4.2-sun/demo/applets/Clock/Clock.class'
echo
echo '$file             '"= '$file'"             # /usr/share/java-1.4.2-sun/demo/applets/Clock/Clock.class
echo '${file#*/}        '"= '${file#*/}'"        #  usr/share/java-1.4.2-sun/demo/applets/Clock/Clock.class
echo '${file##*/}       '"= '${file##*/}'"       #                                              Clock.class
echo '${file%%/*}       '"= '${file%%/*}'"       #
echo '${file%/*}        '"= '${file%/*}'"        # /usr/share/java-1.4.2-sun/demo/applets/Clock

phrase='The quick brown fox is quicker than the dog.'
echo
echo '$phrase           '"= '$phrase'"           # The quick brown fox is quicker than the dog.
echo '${phrase#*quick}  '"= '${phrase#*quick}'"  #           brown fox is quicker than the dog.
echo '${phrase%quick*}  '"= '${phrase%quick*}'"  # The quick brown fox is 
echo '${phrase##*quick} '"= '${phrase##*quick}'" #                             er than the dog.
echo '${phrase%%quick*} '"= '${phrase%%quick*}'" # The 

echo
echo '-- List element concatenation --'

mylist='apple,banana'
echo
echo '$mylist                                       '"= '$mylist'"                                       # apple,banana
echo 'orange,grape${mylist:+,$mylist}               '"= 'orange,grape${mylist:+,$mylist}'"               # orange,grape,apple,banana
echo '${mylist:+$mylist,}peach,pear                 '"= '${mylist:+$mylist,}peach,pear'"                 # apple,banana,peach,pear
echo 'starfruit${mylist:+,$mylist},grapefruit       '"= 'starfruit${mylist:+,$mylist},grapefruit'"       # starfruit,apple,banana,grapefruit
emptylist=""
echo '$emptylist                                    '"= '$emptylist'"                                    # <empty string>
echo 'orange,grape${emptylist:+,$emptylist}         '"= 'orange,grape${emptylist:+,$emptylist}'"         # orange,grape,apple,banana
echo '${emptylist:+$emptylist,}peach,pear           '"= '${emptylist:+$emptylist,}peach,pear'"           # apple,banana,peach,pear
echo 'starfruit${emptylist:+,$emptylist},grapefruit '"= 'starfruit${emptylist:+,$emptylist},grapefruit'" # starfruit,grapefruit

echo
echo '-- Indirection --'

var='name'
echo
echo '$var                      '"= $var"                      # name
echo '$(eval "echo \"\$$var\"") '"= $(eval "echo \"\$$var\"")" # polish.ostrich.racing.champion
echo
echo '==> Avoid ${!var} syntax; it is a bashism and does not work in zsh. <=='

echo
echo '-- Files with spaces --'

echo
echo 'find . -name '\''*foo*'\'' -print0 | while read -d $'\''\\0'\'' f'
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
