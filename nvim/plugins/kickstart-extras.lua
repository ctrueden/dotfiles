-- Enable opt-in kickstart.nvim plugins without modifying init.lua directly.
-- Add more { import = 'kickstart.plugins.X' } entries as desired:
--   debug    - nvim-dap debugger
--   lint     - nvim-lint linter
--   autopairs - auto-close brackets
--   neo-tree - file explorer sidebar
--   gitsigns - git hunk signs + keymaps
return {
	{ import = "kickstart.plugins.debug" },
	{ import = "kickstart.plugins.indent_line" },
}
