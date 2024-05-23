test "$DEBUG" && echo "[dotfiles] Loading plugin 'docker'..."

dksh() {
  hn=$1
  test "$hn" || hn=dksh
  if [ -z "$(docker ps -a | grep ' dksh ')" ]
  then
    docker build -t dksh "$DOTFILES"
  fi
  docker run --hostname "$hn" -it dksh
}
