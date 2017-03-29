" Press F7 to format the HTML in the current buffer
map <F7> :%!fix-html<cr>

" Press F8 to convert the HTML in the current buffer to Mediawiki
map <F8> :%!pandoc -f html -t mediawiki<cr>
