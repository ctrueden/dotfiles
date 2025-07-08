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
	Plugin 'VundleVim/Vundle.vim'

	" Indent Guides
	" See also https://github.com/nathanaelkane/vim-indent-guides/issues/31
	colorscheme default
	Plugin 'nathanaelkane/vim-indent-guides'
	let g:indent_guides_enable_on_vim_startup = 1
	let g:indent_guides_guide_size = 1
	let g:indent_guides_start_level = 2
	"let g:indent_guides_auto_colors = 0
	"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=red ctermbg=darkgray
	"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=darkblue

	Plugin 'taglist.vim'
	Plugin 'bkad/CamelCaseMotion'
	Plugin 'bradford-smith94/quick-scope'
	Plugin 'chikamichi/mediawiki.vim'
	Plugin 'dhruvasagar/vim-table-mode'
	Plugin 'elzr/vim-json'
	Plugin 'jceb/vim-orgmode'
	Plugin 'junegunn/fzf'
	Plugin 'junegunn/limelight.vim'
	let g:limelight_conceal_guifg = '#777777'

	" Vim Sneak, but losing s hurts too much, so remap to - and _
	Plugin 'justinmk/vim-sneak'
	nmap - <Plug>Sneak_s
	nmap _ <Plug>Sneak_S
	xmap - <Plug>Sneak_s
	xmap _ <Plug>Sneak_S
	omap - <Plug>Sneak_s
	omap _ <Plug>Sneak_S

	Plugin 'lepture/vim-velocity'
	Plugin 'michaeljsmith/vim-indent-object'
	Plugin 'rhysd/conflict-marker.vim'
	Plugin 'tpope/vim-abolish'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-repeat'
	Plugin 'tpope/vim-sensible'
	Plugin 'tpope/vim-surround'

	" Make gx use open-browser plugin instead of broken netrw
	" See also https://github.com/vim/vim/issues/4738
	Plugin 'tyru/open-browser.vim'
	let g:netrw_nogx = 1 " disable netrw's gx mapping.
	nmap gx <Plug>(openbrowser-smart-search)
	vmap gx <Plug>(openbrowser-smart-search)

	Plugin 'udalov/kotlin-vim'
	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-scripts/argtextobj.vim'

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

" Source all files in vimrc.d
" Credit to http://stackoverflow.com/a/4500936/1207769
for f in split(glob($DOTFILES . '/vimrc.d/*.vim'), '\n')
	exe 'source' f
endfor

let &cpo=s:cpo_save
unlet s:cpo_save
