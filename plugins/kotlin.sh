test "$DEBUG" && echo "[dotfiles] Loading plugin 'kotlin'..."

alias ktc=kotlinc
alias kts=kscript

# Make konanc and friends available on the CLI. Kotlin downloads them
# on demand and squirrels them away, so let's find the newest one.
newestKonanDir=$(for d in ~/.konan/kotlin-native-prebuilt-*/
do
  v=${d%*/}
  v=${v##*-}
  echo "$v|$d"
done | sort -nr | head -n1 2>/dev/null)
export KONAN_DIR=${newestKonanDir#*|}
if [ -d "$KONAN_DIR" ]
then
  path_prepend "$KONAN_DIR/bin"
fi
