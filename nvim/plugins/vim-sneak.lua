-- Map before loading so sneak.vim's hasmapto() check sees these
-- and skips its default s/S mappings, preserving s for other use.
vim.keymap.set({ 'n', 'x', 'o' }, '-', '<Plug>Sneak_s')
vim.keymap.set({ 'n', 'x', 'o' }, '_', '<Plug>Sneak_S')
vim.pack.add { 'https://github.com/justinmk/vim-sneak' }
