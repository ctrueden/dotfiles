# --== Ruby ==--

# System Ruby is enough here: I use Ruby mainly for local Jekyll previews,
# where each site's Gemfile.lock pins its gems, so no version manager is needed.
#
# Note: Bundler installs gems here, without root, instead of system-wide.
# It appends ruby/<ABI version> itself, so upgrading Ruby gets
# a fresh directory rather than breaking native extensions.
# Gems are not on the PATH; run them via "bundle exec".
export BUNDLE_PATH="$HOME/.local/share/bundle"
