vim.o.autowrite = true -- save automatically at strategic points
vim.o.joinspaces = false -- no double space after . symbol
vim.o.scrolloff = 2 -- the default of 10 is obnoxious
vim.o.shiftwidth = 2 -- two spaces per shift
vim.o.tabstop = 2 -- two spaces per tab

-- Treesitter-based folding (upgrade from foldmethod=indent)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99 -- start with everything open
vim.o.foldenable = true

-- Highlight trailing whitespace and tab/space mix
vim.api.nvim_set_hl(0, "WhiteSpaceEOL", { bg = "lightgreen" })
vim.fn.matchadd("WhiteSpaceEOL", [[\s\+$]])
vim.api.nvim_set_hl(0, "LeadingTabSpaceMix", { bg = "lightgreen" })
vim.fn.matchadd("LeadingTabSpaceMix", [[^\s*\(\t \)\|\( \t\)\s*]])

-- Quick-run current buffer
vim.keymap.set("n", "<leader>r", function()
	local ft = vim.bo.filetype
	local cmd = ({
		java = "java %",
		lua = "lua %",
		python = "python %",
	})[ft]
	if cmd then
		vim.cmd("!" .. cmd)
	end
end, { desc = "[R]un current buffer" })
