let s:cpo_save = &cpo
set cpo&vim

set nocompatible              " be iMproved, required
filetype off                  " required

""" BEGIN VUNDLE CONFIGURATION
let vundlepath = $HOME . "/.vim/bundle/Vundle.vim"
let &runtimepath .= ',' . vundlepath
if filereadable(vundlepath . '/README.md')
	" set the runtime path to include Vundle and initialize
	"set rtp+=vundlepath
	call vundle#begin()

  " let Vundle manage Vundle, required
	Plugin 'gmarik/Vundle.vim'

	Plugin 'nathanaelkane/vim-indent-guides'
	Plugin 'taglist.vim'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-sensible'

	call vundle#end()            " required
endif
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
""" END VUNDLE CONFIGURATION

source $DOTFILES/vimrc.d/compile-exec.vim
source $DOTFILES/vimrc.d/edit-indent-format.vim
source $DOTFILES/vimrc.d/navigation.vim
source $DOTFILES/vimrc.d/smart-tabs.vim
source $DOTFILES/vimrc.d/syntax-highlighting.vim
source $DOTFILES/vimrc.d/tab-completion.vim
source $DOTFILES/vimrc.d/tags.vim
source $DOTFILES/vimrc.d/xml-html.vim

let &cpo=s:cpo_save
unlet s:cpo_save
