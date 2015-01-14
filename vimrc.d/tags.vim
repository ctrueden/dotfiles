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
