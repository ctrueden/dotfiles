vim.o.autowrite = true -- save automatically at strategic points
vim.o.ignorecase = false -- case-sensitive search by default
vim.o.joinspaces = false -- no double space after . symbol
vim.o.scrolloff = 2 -- the default of 10 is obnoxious
vim.o.shiftwidth = 2 -- two spaces per shift
vim.o.smartcase = false -- no automatic case-insensitivity
vim.o.tabstop = 2 -- two spaces per tab

-- Clipboard handling
-- The scheduling is necessary because kickstart.nvim schedules
-- its own setting of the clipboard for startup performance reasons,
-- and we want our override to happen after kickstart.nvim's.
vim.schedule(function()
	if vim.fn.has("linux") == 1 then
		-- Sync " with PRIMARY; middle-click pastes last yank
		vim.o.clipboard = "unnamed"
	else
		-- This platform has no PRIMARY; do not clobber clipboard
		vim.opt.clipboard = ""
	end
end)

-- Treesitter-based folding (upgrade from foldmethod=indent)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99 -- start with everything open
vim.o.foldenable = true

-- Let :term terminals start in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.cmd("startinsert")
	end,
})

-- Highlight trailing whitespace and tab/space mix
vim.api.nvim_set_hl(0, "WhiteSpaceEOL", { bg = "lightgreen" })
vim.fn.matchadd("WhiteSpaceEOL", [[\s\+$]])
vim.api.nvim_set_hl(0, "LeadingTabSpaceMix", { bg = "lightgreen" })
vim.fn.matchadd("LeadingTabSpaceMix", [[^\s*\(\t \)\|\( \t\)\s*]])

-- Toggle terminal background transparency
local transparent = false
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		if transparent then
			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
		end
	end,
})
vim.keymap.set("n", "<leader>bg", function()
	transparent = not transparent
	if transparent then
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
	else
		vim.cmd.colorscheme(vim.g.colors_name)
	end
end, { desc = "Toggle [b]ack[g]round transparency" })

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
