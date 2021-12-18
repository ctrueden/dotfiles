test "$DEBUG" && echo "[zshrc] Initializing..."

# --== zpm ==--

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
	test "$DEBUG" && echo "[zshrc] Installing zpm..."
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi

test "$DEBUG" && echo "[zshrc] Initializing zpm..."
source ~/.zpm/zpm.zsh

# --== oh-my-zsh ==--

test "$DEBUG" && echo "[zshrc] Configuring oh-my-zsh..."

# Disable oh-my-zsh's automatic updates; we'll use "zgen update" instead.
export DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Set the command execution time stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

test "$DEBUG" && echo "[zshrc] Loading oh-my-zsh..."
zpm load @omz
omz_libs=(
  @omz-lib/compfix               # detect completions insecurities
  @omz-lib/completion            # foundational tab completion logic
  @omz-lib/directories           # succinct aliases to work with directories
  @omz-lib/functions             # oh-my-zsh utility functions
  @omz-lib/git                   # git-related utility functions
  @omz-lib/grep                  # grep utility functions and aliases
  @omz-lib/history               # command history configuration
  @omz-lib/key-bindings          # key bindings for emacs/vi behavior
  @omz-lib/misc                  # miscellaneous
  @omz-lib/spectrum              # make using 256 colors in zsh less painful
  @omz-lib/theme-and-appearance  # theme support
)
zpm load $omz_libs

# --== plugins ==--

test "$DEBUG" && echo "[zshrc] Loading plugins..."
zsh_plugins=(
	@omz/vi-mode                          # vi mode CLI instead of emacs
	@omz/brew                             # homebrew completion
	@omz/colorize                         # highlight files based on type with pygmentize
	@omz/cp                               # cpv shows progress while file is copying
	@omz/encode64                         # e64 and d64 for base64 encoding and decoding
	@omz/extract                          # extract command for unpacking many archives
	@omz/git                              # git aliases and improved completion
	@omz/github                           # hub and other github functions
	@omz/history                          # history aliases
	@omz/jsontools                        # json functions
	@omz/last-working-dir                 # return to last dir in new shell instances
#	@omz/macos                            # macOS functions
	@omz/macos,source:macos.plugin.zsh    # TEMP: Until ohmyzsh/ohmyzsh#10518 is merged
	@omz/mvn                              # maven color, aliases and completion
	@omz/npm                              # npm completion
	@omz/urltools                         # urlencode and urldecode functions
	@omz/vundle                           # plugin manager for vim
	@omz/wd                               # wd "warp directory" command
	@omz/web-search                       # web search commands (google etc.)
#	@omz/z                                # z "jump around" command
	@omz/z,source:z.plugin.zsh            # TEMP: Until ohmyzsh/ohmyzsh#10518 is merged
	esc/conda-zsh-completion              # tab completion for conda
	zpm-zsh/check-deps                    # check for needed but missing dependencies
	zpm-zsh/clipboard                     # add pbcopy, pbpaste, and clip functions
	zpm-zsh/colorize                      # colorize the output of various commands
	zpm-zsh/command-not-found             # suggest packages if a command is not found
	zpm-zsh/fast-syntax-highlighting      # syntax highlighting at the prompt
	zpm-zsh/history-search-multi-word     # make ^R search multiple ANDed keywords
	zpm-zsh/zsh-autosuggestions           # suggest completions based on previous ones
	zpm-zsh/zsh-history-substring-search  # history search (e.g. up arrow)
	zsh-users/zsh-completions             # unstable tab completion plugins
)
zpm load $zsh_plugins

test "$DEBUG" && echo "[zshrc] Loading personal plugins..."
for plugin in "$DOTFILES"/plugins/*.sh; do source "$plugin"; done
source "$DOTFILES"/themes/curtis.zsh-theme

# --== zsh vi mode fixes ==--

test "$DEBUG" && echo "[zshrc] Fixing zsh vi mode..."

# Credit to: http://zshwiki.org/home/zle/vi-mode
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case
bindkey -a G end-of-buffer-or-history
bindkey -a u undo
bindkey -a '^R' redo
bindkey '^G' what-cursor-position
vi-backward-word-end() {
	zle vi-forward-word-end
	zle vi-backward-word -n 2 && zle vi-forward-word-end
}
vi-backward-blank-word-end() {
	zle vi-forward-blank-word-end
	zle vi-backward-blank-word -n 2 && zle vi-forward-blank-word-end
}
# TODO: pbcopy / pbpaste clipboard integration

# Make delete key work properly
# Credit to: http://zsh.sourceforge.net/Guide/zshguide04.html#l81
bindkey '\e[3~' delete-char

# Credit to: http://superuser.com/a/533685
vi-search-fix() {
	zle vi-cmd-mode
	zle .vi-history-search-backward
}
autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line
# Credit to: http://superuser.com/a/648046
export KEYTIMEOUT=1
bindkey -sM vicmd '^[' '^G'
bindkey -rM viins '^X'
bindkey -M viins '^X,' _history-complete-newer \
                 '^X/' _history-complete-older \
                 '^X`' _bash_complete-word

# --== zmv ==--

# See: https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zmv

test "$DEBUG" && echo "[zshrc] Configuring zmv..."
autoload -U zmv
alias mmv='noglob zmv -W'

test "$DEBUG" && echo "[zshrc] Done!"
