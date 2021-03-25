# Which shell am I running? zsh? bash?
shell_name() { ps -p $$ | tail -n1 | sed 's/.* //'; }
