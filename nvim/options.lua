vim.o.autowrite = true -- save automatically at strategic points
vim.o.fixendofline = false -- do not mess with EOF newlines
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
-- Without a display (e.g. over SSH) there is no X clipboard to talk to, so
-- send "+ and "* to the local terminal via OSC 52 instead, which tmux forwards.
-- Note: OSC 52 is write-only; terminals refuse to reveal the clipboard, so
-- "+p pastes the last yank from nvim. Paste from the system with the terminal.
local has_display = (vim.env.DISPLAY or "") ~= "" or (vim.env.WAYLAND_DISPLAY or "") ~= ""
local has_osc52, osc52 = pcall(require, "vim.ui.clipboard.osc52") -- nvim 0.10+
if vim.fn.has("linux") == 1 and not has_display and has_osc52 then
	local function paste()
		return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
	end
	vim.g.clipboard = {
		name = "OSC 52",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = paste, ["*"] = paste },
	}
end

vim.schedule(function()
	if vim.fn.has("linux") == 1 and has_display then
		-- Sync " with PRIMARY; middle-click pastes last yank
		vim.o.clipboard = "unnamed"
	else
		-- No PRIMARY here; do not clobber the clipboard, so only "+y sends text out.
		vim.opt.clipboard = ""
	end
end)

-- Treesitter-based folding (upgrade from foldmethod=indent)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99 -- start with everything open
vim.o.foldenable = true

-- Note: In very large buffers (e.g. 40K-line Markdown), treesitter's async
-- parse may never complete, leaving no folds at all. This parses the whole
-- buffer synchronously (a second or so of blocking), then recomputes folds.
vim.keymap.set("n", "<leader>z", function()
	local ok, parser = pcall(vim.treesitter.get_parser)
	if not ok or not parser then
		vim.notify("No treesitter parser for this buffer", vim.log.levels.WARN)
		return
	end
	local lines = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_echo({ { ("Parsing %d lines to compute folds..."):format(lines) } }, false, {})
	vim.cmd.redraw() -- Note: Otherwise the message would not show until after the parse.
	local start = vim.uv.hrtime()
	parser:parse(true)
	vim.cmd("normal! zx")
	local secs = (vim.uv.hrtime() - start) / 1e9
	vim.api.nvim_echo({ { ("Folds refreshed: parsed %d lines in %.1f s"):format(lines, secs) } }, false, {})
end, { desc = "Refresh folds via full treesitter parse ([z])" })

-- Search only visible text: matches inside closed folds are skipped,
-- rather than opening the fold or stopping on it.
vim.opt.foldopen:remove("search")

-- If the cursor is in a closed fold, jump past it and search again,
-- until landing on a visible match. If there is none (the same fold comes
-- around twice), return the cursor to origin, where the search started.
local function skip_closed_folds(forward, origin)
	local seen = {}
	while true do
		local first = vim.fn.foldclosed(".")
		if first == -1 then
			return
		end
		if seen[first] then
			vim.api.nvim_win_set_cursor(0, origin)
			vim.api.nvim_echo({ { "No visible match: " .. vim.fn.getreg("/"), "WarningMsg" } }, false, {})
			return
		end
		seen[first] = true
		if forward then
			vim.api.nvim_win_set_cursor(0, { vim.fn.foldclosedend("."), vim.v.maxcol })
		else
			vim.api.nvim_win_set_cursor(0, { first, 0 })
		end
		-- Note: n/N rather than / or ?, to keep the direction and offset.
		local key = (vim.v.searchforward == 1) == forward and "n" or "N"
		if not pcall(vim.cmd, "normal! " .. key) then
			return
		end
	end
end

for _, key in ipairs({ "n", "N" }) do
	vim.keymap.set("n", key, function()
		local forward = (vim.v.searchforward == 1) == (key == "n")
		local origin = vim.api.nvim_win_get_cursor(0)
		local ok, err = pcall(vim.cmd, "normal! " .. vim.v.count1 .. key)
		if not ok then
			vim.api.nvim_echo({ { err:gsub("^Vim[^:]*:", ""), "ErrorMsg" } }, false, {})
			return
		end
		skip_closed_folds(forward, origin)
	end, { desc = "Next/previous search match, skipping closed folds" })
end

vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = { "/", "?" },
	callback = function()
		if vim.v.event.abort then
			return
		end
		local forward = vim.fn.expand("<afile>") == "/"
		-- Note: The search has not moved the cursor yet when this fires.
		local origin = vim.api.nvim_win_get_cursor(0)
		vim.schedule(function()
			skip_closed_folds(forward, origin)
		end)
	end,
})

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
local transparent = true
local function apply_transparency()
	if transparent then
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
	end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })
apply_transparency() -- colorscheme is already loaded by the time this file runs
vim.keymap.set("n", "<leader>bg", function()
	transparent = not transparent
	if transparent then
		apply_transparency()
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
