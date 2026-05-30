test "$DEBUG" && echo "[dotfiles] Loading plugin 'docker'..."

dksh() {
  hn=${1:-dksh}
  if [ -z "$(docker ps -a | grep ' dksh ')" ]
  then
    docker build -t dksh "$DOTFILES"
  fi
  local ssh_opts=()
  [ -n "$SSH_AUTH_SOCK" ] && ssh_opts=(-v "$SSH_AUTH_SOCK:/ssh-agent" -e "SSH_AUTH_SOCK=/ssh-agent")
  docker run --hostname "$hn" "${ssh_opts[@]}" -it dksh
}
