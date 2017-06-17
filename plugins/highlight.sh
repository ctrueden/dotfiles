# --== terminal syntax highlighting ==--

# Credit to @F1LT3R:
# https://gist.github.com/textarcana/4611277#gistcomment-1701305

# Setup on macOS: "brew install highlight"

if which highlight >/dev/null
then
  # pipe highlight to less
  export LESSOPEN="| $(which highlight) %s --out-format xterm256 --line-numbers --quiet --force --style solarized-light"
  export LESS=" -R"
  alias less='less -m -N -g -i -J --line-numbers --underline-special'
  alias more='less'

  # use "highlight" in place of "cat"
  alias cat="highlight --out-format xterm256 --line-numbers --quiet --force --style solarized-light"

  # To setup JSON syntax highlighting, copy js.lang to json.lang:
  # cp "$(dirname $(brew list highlight | head -n 1))/share/highlight/langDefs/js.lang" "$(dirname $(brew list highlight | head -n 1))/share/highlight/langDefs/json.lang"
fi
