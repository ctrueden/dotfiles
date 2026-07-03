-- after/plugin/mini-surround.lua removes mini.surround's s-prefix keymaps
-- so they don't shadow vim-surround's ys/cs/ds operations.
vim.pack.add {
  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',
}
