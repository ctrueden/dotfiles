-- ftplugin/gitcommit.lua
-- Runs every time a git commit message buffer is opened.
-- Treesitter's gitcommit grammar highlights the whole subject line as a
-- single @markup.heading node (no 50-char overflow concept), and its
-- highlights take priority over both the legacy :syntax gitcommitOverflow
-- group and 'colorcolumn' background shading, so neither is reliably
-- visible. matchadd() sits above both syntax and treesitter highlighting
-- (same mechanism options.lua uses for WhiteSpaceEOL), so use it to flag
-- summary-line characters past column 50.
vim.fn.matchadd("Error", [[\%1l\%>50v.]])
