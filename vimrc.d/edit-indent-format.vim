" Remember previously edited files and registers between editing sessions
set viminfo='20,\"50

" Remember more commands in the history
set history=100

" Show line,col at the bottom of the window
set ruler

" Allow liberal backspacing
set backspace=indent,eol,start

" Use smart indenting
set cindent
" set smartindent "" NB: 'smartindent' is actually not very smart.

" Use two spaces for indentation, and eschew tabs
set expandtab
set shiftwidth=2
set tabstop=2

" Show line numbers. Eclipse spoiled me; ^G is for chumps. ;-)
set nu

" Make vim highlight search matches (using /) as you type them
" This is insanely useful when coupled with search-and-replace for
" interactively testing complex regexes, because you can do:
"     :/regex-pattern
" Followed by:
"     :%s//replacement/options
" Because if you leave off the pattern using s//, it reuses the last one.
set incsearch hlsearch

" When using gq, do not put two spaces after a period
set nojoinspaces

filetype plugin on

" Do not beep on errors
set vb

" Press F2 to justify selected text at 78 chars, similar to man pages.
" Also try selecting with V followed by gq to format text blocks to 80 chars
map <F2> :!(echo '.ll 78'; echo '.nh'; cat -) \| nroff \| sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'<CR>

" Simple code folding -- use zo to open, zc to close, F3 to globally toggle
" (from http://vim.sourceforge.net/tips/tip.php?tip_id=385)
map <F3> :let &fen=!&fen<cr>
set fillchars=stl:_,stlnc:-,vert:\|,fold:\ ,diff:-
set foldlevel=1
set foldmethod=indent
"set foldnestmax=2
let &fen=!&fen
