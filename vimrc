version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim

source $DOTFILES/vimrc.d/compile-exec.vim
source $DOTFILES/vimrc.d/edit-indent-format.vim
source $DOTFILES/vimrc.d/navigation.vim
source $DOTFILES/vimrc.d/syntax-highlighting.vim
source $DOTFILES/vimrc.d/tab-completion.vim
source $DOTFILES/vimrc.d/tags.vim
source $DOTFILES/vimrc.d/xml-html.vim

let &cpo=s:cpo_save
unlet s:cpo_save
