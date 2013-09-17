version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim

""" MISCELLANEOUS

" Remember previously edited files and registers between editing sessions
set viminfo='20,\"50

" Remember more commands in the history
set history=100

" Show line,col at the bottom of the window
set ruler

""" EDITING, INDENTATION AND FORMATTING

" Allow liberal backspacing
set backspace=indent,eol,start

" Use smart indenting
set cindent
" set smartindent "" NB: 'smartindent' is actually not very smart.

" Use two spaces for indentation, and eschew tabs
set expandtab
set shiftwidth=2
set tabstop=2

" When using gq, do not put two spaces after a period
set nojoinspaces

filetype plugin on

" Press F2 to wrap a long line under the cursor at 80 chars
" Also try selecting with V followed by gq to format text blocks to 80 chars
map <F2> 081lBhs<cr><esc>

" Simple code folding -- use zo to open, zc to close, F3 to globally toggle
" (from http://vim.sourceforge.net/tips/tip.php?tip_id=385)
map <F3> :let &fen=!&fen<cr>
set fillchars=stl:_,stlnc:-,vert:\|,fold:\ ,diff:-
set foldlevel=1
set foldmethod=indent
"set foldnestmax=2
let &fen=!&fen

" Press ,= to format XML document with xmllint
map ,= :1,$!xmllint --format -<CR>
"au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" Why use colon when semicolon is faster?
map ; :

""" COMPILATION, EXECUTION, ETC.

" Automatically save prior to compiling or switching files
set autowrite

" -- Begin Melissa's Ant-based compilation --
"let errorFile = '._errorfile'
"
"let antOptions = ''
"let antTarget = 'clean compile'
"let antBuildFile = '/Users/curtis/svn/java/components/bio-formats/build.xml'
"let &errorformat="\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m"
"let &errorformat=&errorformat . "," .
"  \"\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#"
"
"" you could also set makeprg to whatever Ant command, and then just execute
"" :make; however, typically Ant will report errors on files in
"" component/build/src/fully/qualified/package/name/
"" when we want to edit files in
"" component/src/fully/qualified/package/name/
""
"" So the Ant() function essentially duplicates :make, but will automatically
"" convert the filenames.
"map <F2> :call Ant()<cr>
"
"function! Ant()
"  let removeErrorFile = '!rm ' . g:errorFile
"  let ant = '!ant -buildfile ' . g:antBuildFile . ' ' .  g:antOptions .
"    \' ' .  g:antTarget . ' | sed "s/\/build\//\//g" > ' . g:errorFile
"  let openError = 'cg ' . g:errorFile
"
"  silent! execute 'cclose'
"  silent! execute removeErrorFile
"  silent! execute ant
"  silent! execute openError
"  silent! execute 'cwindow'
"  silent! execute 'mode'
"  silent! execute removeErrorFile
"endfunction
" -- End Melissa's Ant-based compilation --

" Press F5 to use javac to compile the current file with QuickFix
set makeprg=javac\ -cp\ $CP:.\ %
set errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
map <F5> :mak<cr>

" Press F6 to execute the current packageless class with no args
map <F6> :!java -cp $CP:. %<<cr>

" Press F7 to format the HTML in the current buffer
map <F7> :%!fix-html<cr>

""" INTERFILE NAVIGATION

" Use gf to jump to source file for class name under the cursor
" Use gc to jump to source file for variable under the cursor's class
" Then use :e#<cr> to jump back to the original source file if desired
" Also try :find MyClass<cr> to jump to the specified class's source file
" (from http://everything101.sourceforge.net/docs/papers/java_and_vim.html)
set path+=.
set path+=~/svn/java/**
set path+=~/cvs/OME-JAVA/src/**
autocmd BufRead *.java set include=^#\s*import
autocmd BufRead *.java set includeexpr=substitute(v:fname,'\\.','/','g')
autocmd BufRead *.java set suffixesadd=.java
map gc gdbgf
" Uncomment the following to use a split window instead of dropping the buffer
" Also try :sfind MyClass<cr> to open the specified class in a split window
"map gf <C-w>f
"map gc gdb<C-w>f

""" TAB COMPLETION

" Ignore these suffixes when tab-completing with (e.g.) :e
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.class

" Let tab be used for keyword completion in insert mode (normally ^N and ^P)
" (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

" Add standard Java syntax file to the dictionary for keyword completion
" (from http://vim.sourceforge.net/tips/tip.php?tip_id=385)
autocmd BufReadPost *.java exe "set dict+=".escape($VIMRUNTIME.'\syntax' .&filetype.'.vim',' \$,')

""" SYNTAX HIGHLIGHTING

" Enable syntax highlighting for dark background
set background=dark
syntax on
" Highlight functions using Java style, and don't flag C++ keywords as errors
" (from http://vim.sourceforge.net/tips/tip.php?tip_id=385)
"let java_highlight_functions="style"
let java_allow_cpp_keywords=1

" Highlight EOL spaces
highlight WhiteSpaceEOL ctermbg=lightgreen
match WhiteSpaceEOL /\s\+$/

" Not yet implemented:
" 1) Use javac instead of jikes to compile 1.5+ source files
" 2) Use ant instead of jikes to compile more 'thoroughly'
" 3) Use ctags to provide smarter keyword completion

let &cpo=s:cpo_save
unlet s:cpo_save

""" TAGS

" First install taglist (http://www.vim.org/scripts/script.php?script_id=273)
" and exuberant ctags (http://ctags.sourceforge.net/)
" Then press F4 to toggle a tags window
" Press ^Wh and ^Wl to navigate between windows
" Press <CR> on a tag to jump to its declaration in the source file

let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
let Tlist_WinWidth=80
"let Tlist_Inc_Winwidth=0
let Tlist_Use_Horiz_Window=1
let Tlist_WinHeight=50
map <F4> :TlistToggle<CR><C-W>j
