test "$DEBUG" && echo "[dotfiles] Loading plugin 'icat'..."

# icat - https://github.com/atextor/icat

if [ -x "$(command -v icat)" -a -x "$(command -v convert)" ]
then
  svgcat() {
    while [ $# -gt 0 ]
    do
      convert -geometry 80x "$1" PNG:- | icat -
      shift
    done
  }
fi
