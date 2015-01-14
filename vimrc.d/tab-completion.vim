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
