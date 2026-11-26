--- Opens the hovered file at the first match of the current content search.
---
--- Bind `plugin search-jump -- rg` (or `fd`) in place of `search --via=...`,
--- so the plugin knows which kind of search is active, and bind
--- `plugin search-jump` in place of `open`. Outside an rg search, or with
--- files selected, opening falls back to the normal `open` action.

local M = {}

-- Note: Yazi does not record which tool produced a search, and fd searches
-- share the search:// URL scheme, so we remember the last one launched.
local set_via = ya.sync(function(state, via) state.via = via end)

local hovered = ya.sync(function(state)
	local cwd = cx.active.current.cwd
	local h = cx.active.current.hovered
	if state.via ~= "rg" or not cwd.spec.is_search then return nil end
	if not h or h.cha.is_dir or #cx.active.selected > 0 then return nil end
	return tostring(cwd.spec.domain), tostring(h.url.path)
end)

local VERY_MAGIC_LITERALS = "[<>=@%%~&/]"

--- Translates a ripgrep (Rust regex) pattern into a very magic vim pattern.
--- This covers the common cases, not the full grammar.
function M.to_vim(pattern)
	local flags = ""
	pattern = pattern:gsub("^%(%?i%)", function() flags = "\\c" return "" end)

	local out, i = {}, 1
	while i <= #pattern do
		local c = pattern:sub(i, i)
		if c == "\\" then
			local n = pattern:sub(i + 1, i + 1)
			if n == "b" then
				-- Note: Vim has separate start and end of word anchors.
				local prev = pattern:sub(i - 1, i - 1)
				out[#out + 1] = (i == 1 or not prev:match("[%w_]")) and "<" or ">"
			elseif n ~= "B" and n ~= "A" and n ~= "z" then
				out[#out + 1] = c .. n
			end
			i = i + 2
		elseif pattern:sub(i, i + 2) == "(?:" then
			out[#out + 1] = "%("
			i = i + 3
		else
			out[#out + 1] = c:match(VERY_MAGIC_LITERALS) and "\\" .. c or c
			i = i + 1
		end
	end

	-- Note: Mirror rg's --smart-case, ignoring escapes like \S and \W.
	if flags == "" then
		flags = pattern:gsub("\\.", ""):match("%u") and "\\C" or "\\c"
	end
	return "\\v" .. flags .. table.concat(out)
end

function M:entry(job)
	local via = job.args[1]
	if via then
		set_via(via)
		return ya.emit("search", { via = via })
	end

	local query, path = hovered()
	if not query then return ya.emit("open", {}) end

	-- Note: +/pat only moves to the matching line; the search() moves to the
	-- match itself, starting from column 0 to accept a match at the cursor.
	-- Note: The shell would otherwise run in the search:// cwd, which is not a
	-- real directory, and Yazi expands %-sequences, so % must be doubled.
	local editor = os.getenv("EDITOR") or "nvim"
	local cmd = string.format(
		"%s %s %s -- %s",
		editor,
		ya.quote("+/" .. M.to_vim(query)),
		ya.quote("+exe 'normal! 0' | call search(@/, 'c')"),
		ya.quote(path)
	)
	ya.emit("shell", {
		(cmd:gsub("%%", "%%%%")),
		cwd = path:match("^(.*)/") or "/",
		block = true,
	})
end

return M
