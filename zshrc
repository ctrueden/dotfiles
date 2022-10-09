test "$DEBUG" && echo "[zshrc] Initializing..."

# --== zpm ==--

if [[ ! -f ~/.zpm/zpm.zsh ]]; then
	test "$DEBUG" && echo "[zshrc] Installing zpm..."
	GIT=git
	test -x $GIT || GIT=/usr/bin/git
	test -x $GIT || GIT=/usr/local/bin/git
	test -x $GIT || {
		echo "[ERROR] No git executable found. Cannot install zpm."
		exit 1
	}
	$GIT clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
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
	@omz/lib/compfix               # detect completions insecurities
	@omz/lib/completion            # foundational tab completion logic
	@omz/lib/directories           # succinct aliases to work with directories
	@omz/lib/functions             # oh-my-zsh utility functions
	@omz/lib/git                   # git-related utility functions
	@omz/lib/grep                  # grep utility functions and aliases
	@omz/lib/history               # command history configuration
	@omz/lib/key-bindings          # key bindings for emacs/vi behavior
	@omz/lib/misc                  # miscellaneous
	@omz/lib/spectrum              # make using 256 colors in zsh less painful
	@omz/lib/theme-and-appearance  # theme support
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
	@omz/macos                            # macOS functions
	@omz/mvn                              # maven color, aliases and completion
	@omz/npm                              # npm completion
	@omz/urltools                         # urlencode and urldecode functions
	@omz/vundle                           # plugin manager for vim
	@omz/wd                               # wd "warp directory" command
	@omz/web-search                       # web search commands (google etc.)
	@omz/z                                # z "jump around" command
	esc/conda-zsh-completion              # tab completion for conda
	zpm-zsh/check-deps                    # check for needed but missing dependencies
	zpm-zsh/clipboard                     # add pbcopy, pbpaste, and clip functions
	zpm-zsh/colorize                      # colorize the output of various commands
#	zpm-zsh/command-not-found             # suggest packages if a command is not found
	zpm-zsh/fast-syntax-highlighting      # syntax highlighting at the prompt
	zpm-zsh/history-search-multi-word     # make ^R search multiple ANDed keywords
	zpm-zsh/zsh-autosuggestions           # suggest completions based on previous ones
	zpm-zsh/zsh-history-substring-search  # history search (e.g. up arrow)
	zsh-users/zsh-completions             # unstable tab completion plugins
)
zpm load $zsh_plugins

export WD_CONFIG=$HOME/.config/wd/warprc

test "$DEBUG" && echo "[zshrc] Loading personal plugins..."
for plugin in "$DOTFILES"/plugins/*.sh "$DOTFILES"/plugins/*.zsh
do
	source "$plugin"
done
source "$DOTFILES"/themes/curtis.zsh-theme

test "$DEBUG" && echo "[zshrc] Done!"
