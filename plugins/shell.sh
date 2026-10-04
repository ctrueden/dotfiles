test "$DEBUG" && echo "[dotfiles] Loading plugin 'shell'..."

interlogin() {
  : << 'DOC'
Reports whether the current shell is interactive and/or login shell.

An *interactive* shell is one where you get a prompt and can type commands.
A *non-interactive* shell is one that executes pre-existing input and exits.
A *login* shell is one that runs when you first log into the machine.

Behavior notes:
  * If shell is non-interactive, it is typically also non-login.
  * On Linux, not all interactive shells are login shells.
  * On macOS, every new Terminal instance *is* a login shell!
DOC

  if [ -n "$ZSH_VERSION" ]; then
    [[ -o interactive ]] && echo interactive
    [[ -o login ]] && echo login
  elif [ -n "$BASH_VERSION" ]; then
    case $- in *i*) echo interactive; esac
    case $- in (*l*) echo login; esac
    case :$BASHOPTS: in (*:login_shell:*) echo login; esac
  else
    # POSIX sh has no reliable way to detect
    >&2 echo "interlogin: unsupported shell"
    return 1
  fi
}
