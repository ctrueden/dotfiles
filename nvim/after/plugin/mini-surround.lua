-- Disable mini.surround entirely by removing all its s-prefix mappings.
-- tpope/vim-surround (in custom plugins) provides surround operations
-- via ys/cs/ds instead, matching pre-nvim muscle memory.
for _, mode in ipairs { 'n', 'x', 'o' } do
  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    if map.lhs:match '^s' then
      pcall(vim.keymap.del, mode, map.lhs)
    end
  end
end
