" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
  let vimDir = '$HOME/.vim'
  let myUndoDir = expand(vimDir . '/undodir')
  " Create dirs
  call system('mkdir ' . vimDir)
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif
