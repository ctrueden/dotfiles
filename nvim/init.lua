-- Loads the Neovim config here into kickstart.nvim, via the stub that
-- setup.sh writes into its lua/custom/plugins/, so that files can come and
-- go here without rerunning setup.sh.

local dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))

-- NB: On Windows, tree-sitter compiles parsers with MSVC's cl.exe, unless CC
-- names another compiler, such as the gcc from scoop.
if vim.fn.has 'win32' == 1 and not vim.env.CC and vim.fn.executable 'gcc' == 1 then
  vim.env.CC = 'gcc'
end

-- For ftplugin/ and after/plugin/, which Neovim then finds by itself.
-- NB: This runs during init.lua, before Neovim loads plugin scripts.
vim.opt.runtimepath:prepend(dir)
vim.opt.runtimepath:append(dir .. '/after')

for _, f in ipairs(vim.fn.glob(dir .. '/plugins/*.lua', false, true)) do
  dofile(f)
end

dofile(dir .. '/options.lua')
