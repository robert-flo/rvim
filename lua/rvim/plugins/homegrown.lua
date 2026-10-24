local ok, homegrown = pcall(require, "homegrown")
if not ok then
	return
end

homegrown.setup({
	bracket_nav = true,
	highlighter = false, -- rvim uses nvim-highlight-colors for virtual color text
	copy = true,
	dir = true,
	md_preview = true,
	pairs = false, -- rvim uses mini.pairs to avoid closing tag collisions
	replace = true,
	runner = true,
	terminal = true,
	tmux = true,
	tiling = true,
})
