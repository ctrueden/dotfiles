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
