"
" smarttabs.vim
"

" Set expandtab variable appropriately for the current file.
" If the file uses tabs, don't expand tabs.
" But if the file doesn't, then expand them to spaces!

function DetectTabs(fname)
  let TAB = '	'
  if search(TAB) > 0
    set noexpandtab
  else
    set expandtab
  endif
endfunction

au BufNewFile,BufRead * call DetectTabs(bufname("%"))


