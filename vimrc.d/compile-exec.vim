" Automatically save prior to compiling or switching files
set autowrite

" Press F5 to run the current program with python
set makeprg=javac\ -cp\ $CP:.\ %
set errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
map <F5> :!python %<cr>

" Press F6 to execute the current packageless class with no args
map <F6> :!java -cp $CP:. %<<cr>
