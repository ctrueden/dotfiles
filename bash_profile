[ -r ~/.bashrc ] && source ~/.bashrc
test -d "$HOME/.byobu" -a -x /usr/bin/byobu-launch && _byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
