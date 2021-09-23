test "$DEBUG" && echo "[zshrc] Initializing..."

# --== zgen ==--

export ZGEN="$HOME/code/shell/zgen"

# Disable oh-my-zsh's automatic updates; we'll use "zgen update" instead.
export DISABLE_AUTO_UPDATE="true"

zgen_install() {
	mkdir -p "$(dirname "$ZGEN")" &&
	(cd "$(dirname "$ZGEN")" && mr up)
}

if [ ! -d "$ZGEN" ]
then
	test "$DEBUG" && echo "[zshrc] Installing zgen..."
	zgen_install
fi

test "$DEBUG" && echo "[zshrc] Initializing zgen..."

source "$ZGEN/zgen.zsh"

omzsh() {
	test "$DEBUG" && echo "[zshrc] Loading oh-my-zsh plugin $@..."
	zgen oh-my-zsh $@
}

load_plugin() {
	test "$DEBUG" && echo "[zshrc] Loading zgen plugin $@..."
	zgen load $@
}

zgen_init() {
	test "$DEBUG" && echo "[zshrc] Initializing zgen..."

	# --== oh-my-zsh ==--
	test "$DEBUG" && echo "[zshrc] Loading oh-my-zsh..."
	zgen oh-my-zsh

	# --== oh-my-zsh plugins ==--
	omzsh plugins/vi-mode           # vi mode CLI instead of emacs
	omzsh plugins/brew              # homebrew completion
	omzsh plugins/colorize          # highlight files based on type with pygmentize
	omzsh plugins/cp                # cpv shows progress while file is copying
	omzsh plugins/encode64          # e64 and d64 for base64 encoding and decoding
	omzsh plugins/extract           # extract command for unpacking many archives
	omzsh plugins/git               # git aliases and improved completion
	omzsh plugins/github            # hub and other github functions
	omzsh plugins/history           # history aliases
	omzsh plugins/jsontools         # json functions
# NB: Does not work with antigen or zgen; see:
# https://github.com/zsh-users/antigen/issues/75
#	omzsh plugins/last-working-dir  # return to last dir in new shell instances
	omzsh plugins/mvn               # maven color, aliases and completion
	omzsh plugins/npm               # npm completion
	omzsh plugins/osx               # OS X functions, including itunes
	omzsh plugins/urltools          # urlencode and urldecode functions
	omzsh plugins/vundle            # plugin manager for vim
	omzsh plugins/wd                # wd "warp directory" command
	omzsh plugins/web-search        # web search commands (google etc.)
	omzsh plugins/z                 # z "jump around" command

	# --== zsh-users plugins ==--
	load_plugin zsh-users/zsh-syntax-highlighting
	load_plugin zsh-users/zsh-history-substring-search
	load_plugin zsh-users/zsh-completions src

	# --== third party plugins ==--
	load_plugin esc/conda-zsh-completion

	# --== my plugins ==--
	load_plugin "$DOTFILES" plugins

	# --== zsh theme ==--
	load_plugin "$DOTFILES" themes/curtis

	test "$DEBUG" && echo "[zshrc] Saving zgen configuration..."
	zgen save
}

# --== oh-my-zsh ==--

test "$DEBUG" && echo "[zshrc] Configuring oh-my-zsh..."

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

# --== zsh history search ==--

test "$DEBUG" && echo "[zshrc] Configuring zsh history search..."

bindkey '^R' history-incremental-search-backward
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

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

test "$DEBUG" && echo "[zshrc] Applying zgen configuration..."
zgen saved || zgen_init

# NB: Explicitly call compinit. Isn't needed for most completions,
# but the esc/conda-zsh-completion plugin doesn't work without it.
test "$DEBUG" && echo "[zshrc] Refreshing completions..."
compinit

# --== zmv ==--

# See: https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zmv

test "$DEBUG" && echo "[zshrc] Configuring zmv..."

autoload -U zmv
alias mmv='noglob zmv -W'

test "$DEBUG" && echo "[zshrc] Done!"
