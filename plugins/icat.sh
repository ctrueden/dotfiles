# icat - https://github.com/atextor/icat

if has icat && has convert
then
  svgcat() {
    while [ $# -gt 0 ]
    do
      convert -geometry 80x "$1" PNG:- | icat -
      shift
    done
  }
fi
