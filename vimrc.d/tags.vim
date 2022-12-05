" First install taglist (http://www.vim.org/scripts/script.php?script_id=273)
" and exuberant ctags (apt install exuberant-ctags)
" Then press F4 to toggle a tags window
" Press ^Wh and ^Wl to navigate between windows
" Press <CR> on a tag to jump to its declaration in the source file

for p in ["/usr/local/bin/ctags", "/usr/bin/ctags"]
  if file_readable(p)
    let Tlist_Ctags_Cmd=p
    let Tlist_WinWidth=80
    "let Tlist_Inc_Winwidth=0
    let Tlist_Use_Horiz_Window=1
    let Tlist_WinHeight=50
    map <F4> :TlistToggle<CR><C-W>j
    break
  endif
endfor
