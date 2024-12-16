test "$DEBUG" && echo "[dotfiles] Loading plugin 'stderred'..."

# stderr in red - https://github.com/ku1ik/stderred
stderred_lib="$CODE_BASE/util/stderred/build/libstderred.so"
if [ -e "$stderred_lib" ]
then
  export LD_PRELOAD="$stderred_lib${LD_PRELOAD:+:$LD_PRELOAD}"
fi
