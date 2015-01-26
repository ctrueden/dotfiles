# --== zgen ==--

export ZGEN="$HOME/code/zsh/zgen"
source "$ZGEN/zgen.zsh"

omz() {
	zgen oh-my-zsh $@
}

zgen_init() {
	# --== oh-my-zsh plugins ==--
	omz
	omz plugins/vi-mode           # vi mode CLI instead of emacs
	omz plugins/brew              # homebrew completion
	omz plugins/colorize          # highlight files based on type with pygmentize
	omz plugins/cp                # cpv shows progress while file is copying
	omz plugins/encode64          # e64 and d64 for base64 encoding and decoding
	omz plugins/extract           # extract command for unpacking many archives
	omz plugins/git               # git aliases and improved completion
	omz plugins/github            # hub and other github functions
	omz plugins/history           # history aliases
	omz plugins/jsontools         # json functions
# NB: Does not work with antigen or zgen; see:
# https://github.com/zsh-users/antigen/issues/75
#	omz plugins/last-working-dir  # return to last dir in new shell instances
	omz plugins/lol               # omg lolbash
	omz plugins/mvn               # maven color, aliases and completion
	omz plugins/npm               # npm completion
	omz plugins/osx               # OS X functions, including itunes
	omz plugins/urltools          # urlencode and urldecode functions
	omz plugins/wd                # wd "warp directory" command
	omz plugins/web-search        # web search commands (google etc.)
	omz plugins/z                 # z "jump around" command

	# --== zsh-users plugins ==--
	zgen load zsh-users/zsh-syntax-highlighting
	zgen load zsh-users/zsh-history-substring-search
	zgen load zsh-users/zsh-completions src

	# --== my plugins ==--
	zgen load "$DOTFILES" plugins

	# --== zsh theme ==--
	zgen load "$DOTFILES" themes/curtis

	zgen save
}

# --== oh-my-zsh ==--

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Set the command execution time stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# --== zsh history search ==--

bindkey '^R' history-incremental-search-backward
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

zgen saved || zgen_init
