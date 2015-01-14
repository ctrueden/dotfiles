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
