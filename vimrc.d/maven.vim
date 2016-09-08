" Press F9 to format the output of the dep-changes script
map <F9> df:i* <ESC>f:cf:: <ESC>f:d$Jdf:df:df:i -> <ESC>f:d$j0
" Press Shift+F9 to format the output of the version-changes script
map <S-F9> dws* <ESC>/.version<CR>dwdws: <ESC>/\/<CR>hC -> <ESC>j0d/version<CR>dwx/\/<CR>d$xkJj0
