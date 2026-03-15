return {
  'justinmk/vim-sneak',
  init = function()
    -- Map before the plugin loads so sneak.vim's hasmapto() check sees these
    -- and skips its default s/S mappings, preserving s for normal vim use.
    vim.keymap.set({ 'n', 'x', 'o' }, '-', '<Plug>Sneak_s')
    vim.keymap.set({ 'n', 'x', 'o' }, '_', '<Plug>Sneak_S')
  end,
}
