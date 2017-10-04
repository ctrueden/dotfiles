" Enable syntax highlighting for dark background
set background=dark
syntax on

set cursorline

" For supported terminals, make colors match Vim's GUI mode; requires 8.0+
" Also requires your terminal to have decent colors, so disable by default.
"set termguicolors

" Highlight functions using Java style, and don't flag C++ keywords as errors
" (from http://vim.sourceforge.net/tips/tip.php?tip_id=385)
"let java_highlight_functions="style"
let java_allow_cpp_keywords=1

" Highlight EOL spaces
highlight WhiteSpaceEOL ctermbg=lightgreen
match WhiteSpaceEOL /\s\+$/

" Highlight leading tab/space mixtures
highlight LeadingTabSpaceMix ctermbg=lightgreen
match LeadingTabSpaceMix /^\s*\(\t \)\|\( \t\)\s*/

" Highlight lines over 80 characters
highlight OverLength ctermbg=brown ctermfg=white guibg=#592929
match OverLength /\%81v.\+/"
