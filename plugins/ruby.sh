test "$DEBUG" && echo "[dotfiles] Loading plugin $(basename "$0")..."

# --== Ruby ==--

# I know I "should" be using rbenv or RVM... but I already use one
# virtual environment management tool, conda, and don't want to add
# another Ruby-specific one to the mix.
#
# I'm happy with system Ruby for now, and the config below makes
# bundler install gems without root access, rather than system-wide.

export GEM_HOME="$HOME/.gem/ruby/default"
