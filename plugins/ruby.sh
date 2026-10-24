# --== Ruby ==--

# System Ruby is enough here: I use Ruby mainly for local Jekyll previews,
# where each site's Gemfile.lock pins its gems, so no version manager is needed.
#
# Note: lib/env.conf sets BUNDLE_PATH, so that Bundler installs gems there,
# without root, instead of system-wide. It appends ruby/<ABI version> itself,
# so upgrading Ruby gets a fresh directory rather than breaking native
# extensions. Gems are not on the PATH; run them via "bundle exec".
